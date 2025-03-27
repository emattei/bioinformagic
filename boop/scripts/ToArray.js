/**
    {
        "api":1,
        "name":"To Array",
        "description":"Convert lines of text into a Python or R array.",
        "author":"Eugenio Mattei",
        "icon":"quote",
        "bias": 5,
        "tags":"array,convert,text,python,r"
    }
**/

function main(input) {
    input.postInfo("#python or #R on the first line for output format.")
    // Check if the input is empty.
    if (!input.text) {
        return input.postInfo("Please provide a text.")
    }
    // Split the input text into lines.
    let lines = input.text.split('\n')
    let quotify = (line) => {
        if ( !line.startsWith("'") ) {
            line = `"${line}`
        }
        if ( !line.endsWith("'") ) {
            line = `${line}"`
        }
        return line
    }
    // Check if the first line is #python or #R and set the output format.
    let outputFormat = lines[0].startsWith("#") ? lines.shift().replace("#", "").toLowerCase() : 'python'
    // Map over the lines and quotify them.
    lines = lines.map(quotify)
    // Set the output
    input.text = outputFormat === 'python' ? `[${lines.join(",")}]` : `c(${lines.join(",")})`
}