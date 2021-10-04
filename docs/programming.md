# *Assembler Exemplar* Programmer's Documentation

This document is meant to explain the underlying program design of
*Assembler Exemplar*, including the various scripts, Scenes, and Singletons
used in the Godot Engine.

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

Each chip will have a dictionary which has integer keys mapped to arrays
[or dictionaries?]
of integers. Each integer key contains a combination of the bits from all input
values, and the corresponding array contains integer values representing each
output that should
For example, the `nand` dictionary would be as follows:
(may revise so mapped values are dictionaries, rather than arrays)

```
# (may revise so mapped values are dictionaries, rather than arrays)
var nand := {
    0b00: [1]
    0b01: [1]
    0b10: [1]
    0b11: [0]
}
```

(The use here of the `0b` binary literal notation provided by GDScript is
a stylistic decision, to make it easier to see the bit values for
each set of inputs. The key values could also be written as 0, 1, 2, and 3.)

Given values for *a* and *b*, we can use this
dictionary to find the correct output by bit-shifting *a* to the left
using the left-shift operator `<<` to make room on the right for *b*'s bits,
then combining the two with the bitwise OR operator `|`.

Given inputs *a* and *b* for a two-input chip like the NAND gate, we
can use the chip's corresponding dictionary to get the correct
output by bit-shifting *a* to the left (`<<`) to make room for *b*'s bits,
then combining the two with bitwise OR (`|`) to create the dictionary key.
In GDScript (and Python), key can be created with the expression
`a << l | b`, where `l` is the number of bits in *a*
(l = 1 for the NAND gate).
If the chip has more than two inputs, more bit-shifting and bitwise OR
operations will be needed to incorporate all inputs into the key.
In GDScript, `int` values are 64-bit integers, so the total bits of the
chip inputs cannot exceed 64 for this type of dictionary.
