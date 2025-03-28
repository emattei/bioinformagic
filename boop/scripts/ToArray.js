/**
    {
        "api":1,
        "name":"To Array",
        "description":"Convert lines of text into a Python or R array.",
        "author":"Eugenio Mattei",
        "icon":"quote",
        "bias": 5,
        "tags":"array,convert,list"
    }
**/

function main(input) {
    input.postInfo("/python or /R on the first line for output format.")
    // Check if the input is empty.
    if (!input.text) {
        return input.postInfo("Please provide a text.")
    }
    // Split the input text into lines.
    let lines = input.text.split('\n')
    // Check if the first line is #python or #R and set the output format.
    let outputFormat = lines[0].startsWith("/") ? lines.shift().replace("/", "").toLowerCase() : 'python'
    // Define the quotify function.
    let quotify = (line) => {
        if (!line.trim()) {
            return null; // Skip empty lines
        }
        if (!line.startsWith('"')) {
            line = `"${line}`; // Add a quote at the beginning
        }
        if (!line.endsWith('"')) {
            line = `${line}"`; // Add a quote at the end
        }
        return line;
    };

    // Filter out null values (empty lines) after mapping.
    lines = lines.map(quotify).filter(line => line !== null);
    // Set the output
    input.text = outputFormat === 'python' ? `[${lines.join(",")}]` : `c(${lines.join(",")})`
}