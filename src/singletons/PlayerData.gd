extends Node

# The PlayerData singleton provides methods to access and modify player data.
# In the background, it will do the following:
#    * Maintain up-to-date player data within in-memory data structures
#      for fast access and modification.
#    * Append operations to the recovery file for the current level.
#    * Periodically update the current level's .sav file
#      (this should also clear the recovery file).


# Level-specific data for the current level.
# This data structure will look like the JSON object described by the
# level's .sav file, but with GDScript integers as lookup keys in the
var _level_data := {}


# The name of the current level. When the player opens a level in the Chip
# Designer, this should be updated.
var current_level := "" setget set_current_level

# Set current level and load its data.
func set_current_level(level: String):
	current_level = level

	level_data = FileIO.load_savfile("user://save/" + level + ".sav")



# Create a new solution for the current level.
func create_solution(solution:="Solution 1") -> int:
	pass


# Rename a solution for the current level.
func rename_solution(solution: String, name: String) -> int:
	pass


# Delete a solution for the current level.
func delete_solution(solution: String) -> int:
	pass


# move an input's x/y position, returning error code
func move_input(solution: String, input: String, pos: Vector2) -> int:
	# Get the sub-dictionary for the particular solution being modified
	var solution : Dictionary = level_data["solutions"][input]

	# Get the sub-dictionary for inputs
	var inputs : Dictionary = solution["inputs"]

	level_data["solutions"][solution]["inputs"][input] = [pos.x, pos.y]

	inputs[rec_op["input"]] = rec_op["pos"]

	return OK


# move an ouput's x/y position in sav_data as specified by rec_op,
# returning error code
func move_output(sav_data: Dictionary, rec_op: Dictionary) -> int:
	pass


# add a chip to sav_data according to the "id", "type", and "pos"
# specified in rec_op
func add_chip(sav_data: Dictionary, rec_op: Dictionary) -> int:
	pass


# delete a chip from sav_data according to the "id" specified in
# rec_op
func delete_chip(sav_data: Dictionary, rec_op: Dictionary) -> int:
	pass


# add a new wire to sav_data according to the "id" and "pos" specified
# in rec_op
func add_wire(sav_data: Dictionary, rec_op: Dictionary) -> int:
	pass


# delete a wire from sav_data according to the "id" value specified by
# rec_op's "id" value.
func delete_wire(sav_data: Dictionary, rec_op: Dictionary) -> int:
	pass


# add a segment with id "id" and position "pos" to wire "wire_id"
# in sav_data using values given in rec_op
func add_segment(sav_data: Dictionary, rec_op: Dictionary) -> int:
	pass


# delete a segment with id "id" from wire "wire_id"
# in sav_data using values given in rec_op
func delete_segment(sav_data: Dictionary, rec_op: Dictionary) -> int:
	pass


# rename the solution in sav_data specified by rec_op's "old" key with
# the new name given in the "new" key
func rename_solution(sav_data: Dictionary, rec_op: Dictionary) -> int:
	pass
