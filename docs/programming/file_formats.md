###### *Assembler Exemplar* Programmer's Documentation
# File Formats

## Solution Save Files

Solution files describe the contents of the player's solutions to a
particular level.

Each solution file uses the `.sav` extension, and contains a
Base64 encoding of a GDScript Dictionary, endoded using Godot's `Marshals`
class.
The file is compressed by Godot using the
[Zstandard](https://facebook.github.io/zstd/)
compression algorithm.
It should consist of a single Dictionary with contents similar to the
following:

```
{
    "Solution 1": {
        "inputs": {
            "some-input-name": [x, y],
            ...
        },
        "outputs": {
            "some-output-name": [x, y],
            ...
        },
        "chips": [
            { "type": "chip-type", "pos": [5, 0] },
            ...
        ],
        "wires": {
            1: {
                1: { "some_segment_id", "pos": [x, y] },
                ...
            },
            ...
        }
    },
    ...
}
```

Each key's purpose is described in more detail below.

* Solution name - At the top level, we have a dictionary mapping solution
                  names to corresponding dictionaries.
* `"inputs"` - This object should contain an entry for each of the chip inputs.
             Each entry will have a string key mapped to an array of two
             numbers representing the x and y values in the input's position.
* `"outputs"` - This object should contain an entry for each of the chip
              outputs. Each entry will have a string key mapped to an array
              of two numbers representing the x and y values in the output's
              position.
* `"chips"` - An array containing chip objects.

            Each of these chip objects will have the following keys:

                - `"type"` - The type of the chip as a string.
                - `"pos"` - A an array of two numbers representing the x and y
                          coordinates of the chip.

* `"wires"` - An array of arrays representing wires.
            Each wire array in turn contains arrays representing segments.
            Each segment array contains a start position and end position,
            where a position is an array containing an x and y value.


## Recovery Data (NOT YET USED)

The recovery data format will consist of lines of text, each
containing a Base64 encoding of a GDScript Dictionary which describes
modifications to the solutions of a particular level.

The structure of the Dictionary will vary according to the type of operation:

* `"move_input"`

    Move an input's x/y position in sav_data as specified.

    Example:
    ```
    { "op": "move_input", "solution": "solution_name", "input": "some_input", "pos": [x, y] }
    ```

* `"move_output"`

    Add a chip to sav_data according to the "id", "type", and "pos"
    specified.

    Example:
    ```
    { "op": "move_output", "solution": "solution_name", "output": "some_output", "pos": [x, y] }
    ```

* `"add_chip"`

    Add a chip to sav_data according to the "id", "type", and "pos"
    specified.

    Example:
    ```
    { "op": "add_chip", "solution": "solution_name", "id": "new_id", "type": "some_type", "pos": [x, y] }
    ```

* `"delete_chip"`

    Delete a chip from sav_data according to the "id" specified.

    Example:
    ```
    { "op": "delete_chip", "solution": "solution_name", "id": "some_id" }
    ```

* `"add_wire"`

    Add a new wire to sav_data according to the "id" and "pos" specified.

    Example:
    ```
    { "op": "add_wire", "solution": "solution_name", "id": "new_id" }
    ```

* `"delete_wire"`

    Delete a wire from sav_data according to the "id" value specified by
    the "id" value.

    Example:
    ```
    { "op": "delete_wire", "solution": "solution_name", "id": "some_id" }
    ```

* `"add_segment"`

    Add a segment with id "id" and position "pos" to wire "wire_id"
    in sav_data using values given.

    Example:
    ```
    { "op": "add_segment", "solution": "solution_name", "wire_id": "parent_wire_id", "id": "some_id", "pos": [x, y] }
    ```

* `"delete_segment"`

    Delete a segment with id "id" from wire "wire_id"
    in sav_data using values given.

    Example:
    ```
    { "op": "delete_segment", "solution": "solution_name", "wire_id": "parent_wire_id", "id": "some_id"}
    ```

* `"rename_solution"`

    Rename the solution in sav_data specified by the "old" key with
    the new name given in the "new" key

    Example:
    ```
    { "op": "rename_solution", "old": "solution_name", "new": "new_solution_name" }
    ```
