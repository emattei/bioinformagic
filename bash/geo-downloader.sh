#!/usr/bin/env bash

# Make sure that the script will exit in case of error.
set -Eeuo pipefail

# Call the cleanup function in case an error or interruptions occurs.
trap cleanerr SIGINT SIGTERM ERR
trap cleanexit EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-p] [-o output_folder] -g GEO

The script takes in input a GEO id and download all the fastqs 
associated to it along with metadata describing the data.
The GEO id could be a sample id (GSM*) or a series id (GSE*)

Dependencies:

    (Debian-based linux) sudo apt install ncbi-entrez-direct sra-toolkit
    (Conda) conda install -c bioconda entrez-direct sra-tools

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-g, --geo       GEO id
-p, --cpu       Number of cores to use. Be carefull to not kill your I/O. Default: 1
-o, --output    Path to the output folder. 
                Default: new folder in the current directory using the GEO id as name.
EOF
  exit
}

cleanerr() {
  # Clean up after an error
  if [[ -d ${output} ]]
  then
    msg "Cleaning up directory '${output}'"
    rm -r ${output}
  fi
}

cleanexit() {
  # Clean the prefetch tmp folder
  if [[ -d "${output}/prefetch" ]]
  then
    msg "Cleaning up directory '${output}'"
    rm -r "${output}/prefetch"
  fi
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}
export -f msg

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # Default values of variables set from params
  cpu=1
  output=''
  
  args=("$@")

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -p | --cpu) 
               cpu="${2-}"
               shift
               ;;
    -g | --geo) 
               geo="${2-}"
               shift
               ;;
    -o | --output) 
               output="${2-}"
               shift
               ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  # Check required params and arguments
  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"
  [[ -z "${geo-}" ]] && die "Missing required parameter: GEO id"
  [[ -z "${output-}" ]] && output="${geo}" # Default output to GEO id
  [[ -d "${output}" ]] && die "Output directory already exists"

  return 0
}

download(){
    # Helper function for downloading the fastqs.
    # $1: SRX; $2: output folder
    msg "Downloading ${1} in ${2}"
    prefetch -q -O "${2}/prefetch" "${1}"
    vdb-validate -q "${2}/prefetch/${1}"
    fastq-dump -I --gzip --split-files -O "${2}" "${1}"
}
export -f download

parse_params "$@"
setup_colors

# Create the output folder and the temp folder for SRA prefetch
msg "Creating output folder in ${output}"
mkdir -p "${output}/prefetch"

# Find all the SRA associated with the GEO id
msg "Querying for all the SRA ids associated with ${geo}"
mapfile -t SRA_IDS < <(esearch -db gds -query "${geo}[ACCN] AND GSM[ETYP]" |\
                       efetch -format docsum | \
                       xtract -pattern ExtRelation -element TargetObject)

# Collect all the metadata associated with the SRA ids
for id in "${SRA_IDS[@]}"
do
   msg "Downloading metadata for ${id}"
   esearch -db sra -query ${id} |\
    efetch -format runinfo >> "${output}/${geo}-metadata.temp"
done

# Removing the duplicated headers and empty lines
sort "${output}/${geo}-metadata.temp" | uniq | awk 'NF' > "${output}/${geo}-metadata.csv"
rm "${output}/${geo}-metadata.temp"

# Download the fastq files
msg "Starting fastq downloads"
esearch -db gds -query "${geo}[ACCN] AND GSM[ETYP]" | \
 efetch -format docsum | \
 xtract -pattern ExtRelation -element TargetObject | \
 xargs -t -n 1 -P "${cpu}" -I {} bash -c 'download {} '"${output}"
