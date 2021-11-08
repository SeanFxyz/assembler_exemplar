# Dmux Gate

## Description

The "Dmux" ("*D*e*mu*ltiple*x*or") gate has two inputs and two outputs. One of
the inputs is a "selector" that selects which output the other input will be
routed to.

## Operations

```
Inputs: in, sel
Outputs: a, b
Function: *if* sel=0 *then* {a=in, b=0} *else* {a=0, b=in}
```
* Adapted from *The Elements of Computing Systems* Pg. 21

## Additional Information

Boolean Logic Table:

```
in   sel   |   a   b
--------------+--------
0    0     |   0   0
1    0     |   1   0
0    1     |   0   0
1    1     |   0   1
```

