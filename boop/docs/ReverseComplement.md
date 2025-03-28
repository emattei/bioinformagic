# Reverse Complement

## Description

The `ReverseComplement` function processes input DNA sequences, validates them, and returns their reverse complement.

## Steps

1. Validates that the input is not empty and contains only valid DNA characters (`A`, `T`, `G`, `C`).
2. Splits the input into lines and processes each line individually.
3. Computes the reverse complement of each line by reversing the sequence and replacing each nucleotide with its complement:
     - `A ↔ T`
     - `G ↔ C`
4. Joins the processed lines back together and updates the `input.text` property.

## Parameters

- **`input`** (Object): The input object provided by the Boop scripting environment.
- **`input.text`** (string): The DNA sequence as a string, with each line representing a separate sequence.

## Returns

- **`void`**: Modifies the `input.text` property to contain the reverse complement of the input sequence.

## Throws

- **Error**: If the input is empty or contains invalid characters that are not part of a DNA sequence.