# To Array

## Description

The `ToArray` function converts lines of text into a Python list or an R vector based on the specified format.

## Steps:
1. Detects the output format (`/python` or `/R`) from the first line of the input text.
2. Converts each subsequent line into a quoted string.
3. Outputs the result as a Python list or R vector.

## Parameters

- **`input`** (Object): The input object provided by the Boop scripting environment.
- **`input.text`** (string): The text input to be processed.
- **`input.postInfo`** (Function): A function to display informational messages to the user.

## Examples

### Python Example
**Input:**
```
/python
apple
banana
cherry
```

**Output:**
```python
["apple", "banana", "cherry"]
```

### R Example
**Input:**
```
/R
apple
banana
cherry
```

**Output:**
```R
c("apple", "banana", "cherry")
```

## Returns

- **`void`**: Modifies the `input.text` property to contain the formatted array.