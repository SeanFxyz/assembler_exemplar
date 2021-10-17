###### *Assembler Exemplar* Programmer's Documentation
# File Formats

## Save Files

Each save file, or `savfile`, use the `.sav` extension, and is essentially
a JSON text file compressed by Godot using the
[Zstandard](https://facebook.github.io/zstd/) compression algorithm.
It should consist of a single JSON object with similar contents to the
following:

```
{
    "level": "level-name",
    "solutions": {
        "some-solution": {
            "inputs": {
                "some-input-name": [x, y],
                ...
            },
            "outputs": {
                "some-output-name": [x, y],
                ...
            },
            "chips": {
                "some-chip-id": { "type": "chip-type", "pos": [5, 0] },
                ...
            },
            "wires": {
                "some-wire-id": {
                    "id": { "some_segment_id", "pos": [x, y] },
                    ...
                },
                ...
            }
        },
        ...
    }
}
```

Each key's purpose is described in more detail below.

* `"level"` - Maps to a string containing the level's name.
* `"solutions"` - Maps to an object containing all of the user's solutions.
* Solution object - There is one named "some-solution" in above example.
                    This maps to an object describing the content of one of
                    the player's solutions to this level.
* `"inputs"` - This object should contain an entry for each of the chip inputs.
             Each entry will have a string key mapped to an array of two
             numbers representing the x and y values in the input's position.
* `"outputs"` - This object should contain an entry for each of the chip
              outputs. Each entry will have a string key mapped to an array
              of two numbers representing the x and y values in the output's
              position.
* `"chips"` - An object mapping chip ID strings to objects representing chip
            components placed by the player.

            Each of these chip objects will have the following keys:

                - `"type"` - The type of the chip as a string.
                - `"pos"` - A an array of two numbers representing the x and y
                          coordinates of the chip.

* `"wires"` - Maps wire ID strings wire objects
            Each wire object in turn maps segment IDs to segment objects,
            which have the following keys:
                - `"id"` - The id of the segment.
                - `"pos"` - The position of the segment


## Recovery Data

The recovery data format will consist of lines of text, each
containing a JSON object that describes an alteration to the chip.

The structure of the JSON object will vary according to the type of operation.

* `"move_input"`

    Move an input's x/y position in sav_data as specified.

    Example:
    ```
    { "op": "move_input", "input": "some_input", "pos": [x, y] }
    ```

* `"move_output"`

    Add a chip to sav_data according to the "id", "type", and "pos"
    specified.

    Example:
    ```
    { "op": "move_output", "output": "some_output", "pos": [x, y] }
    ```

* `"add_chip"`

    Add a chip to sav_data according to the "id", "type", and "pos"
    specified.

    Example:
    ```
    { "op": "add_chip", "id": "new_id", "type": "some_type", "pos": [x, y] }
    ```

* `"delete_chip"`

    Delete a chip from sav_data according to the "id" specified.

    Example:
    ```
    { "op": "delete_chip", "id": "some_id" }
    ```

* `"add_wire"`

    Add a new wire to sav_data according to the "id" and "pos" specified.

    Example:
    ```
    { "op": "add_wire", "id": "new_id" }
    ```

* `"delete_wire"`

    Delete a wire from sav_data according to the "id" value specified by
    the "id" value.

    Example:
    ```
    { "op": "delete_wire", "id": "some_id" }
    ```

* `"add_segment"`

    Add a segment with id "id" and position "pos" to wire "wire_id"
    in sav_data using values given.

    Example:
    ```
    { "op": "add_segment", "wire_id": "parent_wire_id", "id": "some_id", "pos": [x, y] }
    ```

* `"delete_segment"`

    Delete a segment with id "id" from wire "wire_id"
    in sav_data using values given.

    Example:
    ```
    { "op": "delete_segment", "wire_id": "parent_wire_id", "id": "some_id"}
    ```

* `"rename_solution"`

    Rename the solution in sav_data specified by the "old" key with
    the new name given in the "new" key

    Example:
    ```
    { "op": "rename_solution", "old": "solution_name", "new": "new_solution_name" }
    ```
