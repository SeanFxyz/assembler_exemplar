# Mux Gate

## Description

The "Mux" ("*Mu*ltiple*x*or") gate has three inputs and one output. One of the
inputs is a "selector" that selects one of the two other bits to be output.

## Operations

```
Inputs: a, b, sel
Outputs: out
Function: *if* sel=0 *then* out=a *else* out=b
```
* Adapted from *The Elements of Computing Systems* Pg. 20-21

## Additional Information

Boolean Logic Table:

```
a   b   sel   |   out
--------------+---------
0   0   0     |   0
0   1   0     |   0
1   0   0     |   1
1   1   0     |   1
0   0   1     |   0
0   1   1     |   1
1   0   1     |   0
1   1   1     |   1
```

