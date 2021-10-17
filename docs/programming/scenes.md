###### *Assembler Exemplar* Programmer's Documentation
# Godot Scenes

A scene is essentially a tree of Nodes that can either comprise our current
game world or can be instantiated as a sub-tree within another scene.

Any sub-tree of our main scene tree that we want to have duplicates of
should probably be made into its own scene, as should any logically
cohesive component of the application that we want to be able to design,
build and test separately from other parts, as long as making it its own
scene doesn't complicate things too much.
