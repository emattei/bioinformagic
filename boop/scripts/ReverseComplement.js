/**
    {
        "api":1,
        "name":"Reverse Complement",
        "description":"Reverse complement a DNA sequence",
        "author":"Eugenio Mattei",
        "icon":"quote",
        "bias": 5,
        "tags":"complement,reverse,rc"
    }
**/

function main(input) {
    // Check if the input is empty.
    if (!input.text) {
        return input.postInfo("Please provide a DNA sequence.")
    }
    // Check if the input is a DNA sequence.
    if (!/^[ATGCatgc\n]+$/.test(input.text)) {
        (`${ input.length } lines removed`)
        return input.postError("Please provide a valid DNA sequence.")
    }
    // Split the input text into lines.
    let lines = input.text.split('\n')
    // Define the complement dictionary.
    let complement = {
        'A': 'T',
        'T': 'A',
        'G': 'C',
        'C': 'G'
    }
    // Map over the lines, split them into characters, reverse them, map over them and join them back together.
    let reverseComplement = lines.map(line => {
        return line.toUpperCase().split('').reverse().map(n => complement[n]).join('')
    })
    // Join the lines and set the output
    input.text = reverseComplement.join('\n')
}
