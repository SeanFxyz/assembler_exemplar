###### *Assembler Exemplar* Programmer's Documentation:
# Godot Singletons

In the Godot Engine, singletons are Nodes which have one instance that is
globally accessible from all scripts. They are good for holding data
or code that needs to persist between scenes or simply needs to be
accessible to various parts of the program.

## `PlayerData`

`PlayerData` provides access to player-specific data, including the content
of the player's solutions to levels, level completion status, scores, etc.
It abstracts access to this data, so other parts of the program do not need
deal directly with the serialization or storage of this data.

For now, it will be using the `FileIO` singleton to save data in the file
formats specified [here](file_formats.md), but future web or otherwise
cloud-based implementations of *AE* may use other data storage methods,
and `PlayerData` can be updated to use those instead, while
gameplay-related code can simply rely on `PlayerData` to store data
appropriately.

## `ChipIO`

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


## `FileIO`

This singleton is home to code related to reading and writing *AE*'s
file formats.
It should probably only be used directly by data-handling
singletons, such as `PlayerData`, so that other parts of the application
can rely on these singletons as a layer of abstraction for access to
different kinds of data, and the specifics of data storage and access
can be changed without adjusting gameplay-related code.
