# *Assembler Exemplar* Programmer's Documentation

This document is meant to explain the underlying program design of
*Assembler Exemplar*, including the various scripts, Scenes, and Singletons
that will be created for the Godot Engine implementation, as well as structures
and formats used for handling player data.

## Singletons

In the Godot Engine, singletons are Nodes which have one instance that is
globally accessible from all scripts. They are good for holding data
or code that needs to persist between scenes or simply needs to be
accessible to various parts of the program.

### `ChipIO`

The `ChipIO` Singleton include pre-populated dictionaries mapping chip
inputs to the corresponding outputs, which will be used by nodes to
simulate player-created chips and verify them during testing.
Since more than one part of the program needs to know the correct output of
a chip given a particular input, this singleton centralizes that
functionality.

Each chip will have a dictionary which has integer keys mapped to dictionaries
containing output values.
Each integer key contains a combination of the bits from all input
values, and the corresponding dictionary contains integer values
representing each output.
For example, the `nand` dictionary would be as follows:

```
var nand := {
    0b00: { "out": 1 },
    0b01: { "out": 1 },
    0b10: { "out": 1 },
    0b11: { "out": 0 },
}
```

(The use here of the `0b` binary literal notation provided by GDScript is
a stylistic decision, to make it easier to see the bit values for
each set of inputs. The key values could also be written as 0, 1, 2, and 3.)

Given values for ***a*** and ***b***, we can use this
dictionary to find the correct output by bit-shifting ***a*** to the left
using the left-shift operator `<<` to make room on the right for ***b***'s bits,
then combining the two with the bitwise OR operator `|`.

Given inputs ***a*** and ***b*** for a two-input chip like the NAND gate, we
can use the chip's corresponding dictionary to get the correct
output by bit-shifting ***a*** to the left (`<<`) to make room for ***b***'s
bits, then combining the two with bitwise OR (`|`) to create the dictionary
key.
In GDScript (and Python), the key can be created with the expression
`a << l | b`, where `l` is the number of bits in ***a***
(`l = 1` for the NAND gate).
Following is a visual example of this process:

Let's say we have a chip that has 4-bit input ***a***, 2-bit input ***b***,
and one 6-bit output.
The dictionary for this chip may look like this:

```
var weird_chip := {
    0b000000: { "out": 0b000001 },
    0b000001: { "out": 0b000010 },
    0b000010: { "out": 0b000011 },
    0b000011: { "out": 0b000100 },
    0b000100: { "out": 0b000101 },
    0b000101: { "out": 0b001011 },
    ...
```

We are given `a=0b0101` and `b=0b11`.
We bit-shift ***a*** leftward by total size of the remaining inputs:
```
0b0101 << 2 = 0b010100
```
We then bitwise OR ***a*** and ***b***, which fills in ***b***'s bits into
the space on the right that was cleared by bit-shifting:

```
a, shifted: 010100
b:              11
bitwise-or: 010111
```

So our key is `0b010111`.

This process is generalized by the following pseudo-code, although the use
of loops is not advised in the actual implementation for performance reasons:

```
key = 0
l = total length of remaining unincorporated inputs
for i in inputs:
    key = key | (i << l)
    l = l - length(i)
```

In GDScript, `int` values are 64-bit integers, so the total bits of the
chip inputs cannot exceed 64 for this type of dictionary.


## File Formats

### Save Files

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


### Recovery Data

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
