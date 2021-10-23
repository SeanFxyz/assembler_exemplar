extends Node

# The PlayerData singleton provides methods to access and modify player data.
# In the background, it will do the following:
#    * Maintain up-to-date player data within in-memory data structures
#      for fast access and modification.
#    * Append operations to the recovery file for the current level.
#    * Periodically update the current level's .sav file
#      (this should also clear the recovery file).

# template structure for player solutions
var _solution_template := {
	"inputs": {},
	"outputs": {},
	"chips": {},
	"wires": {},
}


# Solutions data for the current level.
var solutions : Dictionary


# The name of the current level. When the player opens a level in the Chip
# Designer, this should be updated.
var current_level := "" setget set_current_level


# Set current level and load its data.
# If the level has no existing solutions, create one with the default
# name.
func set_current_level(level: String) -> bool:

	solutions = FileIO.load_leveldata(level)

	current_level = level

	return true


# Current solution to be updated. Should be updated when the user
# switches solutions.
var current_solution : String setget set_current_solution


# Sets the current solution and updates relevant references accordingly.
func set_current_solution(new_value: String) -> void:
	current_solution = new_value

	if not solutions.has(current_solution):
		create_solution(current_solution

	inputs  = solutions[current_solution]["inputs"]
	outputs = solutions[current_solution]["outputs"]
	chips   = solutions[current_solution]["chips"]
	wires   = solutions[current_solution]["wires"]


# Create a new solution for the current level.
func create_solution(new_name: String) -> bool:
	if solutions.has(new_name):
		return false
	else:
		solutions[new_name] = _solution_template.duplicate()
		return true


# Rename a solution for the current level.
func rename_solution(old_name: String, new_name: String) -> bool:
	solutions[new_name] = solutions[old_name].duplicate()
	if current_solution == old_name:
		set_current_solution(new_name)
	solutions.erase(old_name)

	return true


# Delete a solution for the current level.
func delete_solution(sol_name: String) -> bool:
	# If the current solution is the one to be deleted, change
	# it to the first solution.
	if current_solution == sol_name:
		set_current_solution(solutions.keys()[0])

	solutions.erase(sol_name)

	return true


# set an input's x/y position
set_input_pos(solution: String, input: String, pos: Vector2) -> bool:
	inputs["pos"] = [pos.x, pos.y]
	return true


# set an output's x/y position
set_output_pos(input: String, pos: Vector2) -> bool:
	outputs["pos"] = [pos.x, pos.y]
	return true


# Update solution data from recovery data
func update_from_rec(solutions: Dictionary, rec_data: Array) -> int:

	var err := OK

	for rec_op in rec_data:
		var op_type : String = rec_op["op"]

		if   op_type == "move_input":
			err = move_input(sav_data, rec_op)
		elif op_type == "move_output":
			err = move_output(sav_data, rec_op)
		elif op_type == "add_chip":
			err = add_chip(sav_data, rec_op)
		elif op_type == "delete_chip":
			err = delete_chip(sav_data, rec_op)
		elif op_type == "add_wire":
			err = add_wire(sav_data, rec_op)
		elif op_type == "delete_wire":
			err = delete_wire(sav_data, rec_op)
		elif op_type == "extend_wire":
			err = extend_wire(sav_data, rec_op)
		elif op_type == "merge_wire":
			err = merge_wire(sav_data, rec_op)
		elif op_type == "split_wire":
			err = split_wire(sav_data, rec_op)
		elif op_type == "rename_solution":
			err = rename_solution(sav_data, rec_op)
		else:
			err = FAILED

		if err != OK:
			break

	return err


# move an input's x/y position in sav_data as specified by rec_op,
# returning error code
func move_input(sav_data: Dictionary, rec_op: Dictionary) -> int:
	# Get the sub-dictionary for the particular solution being modified
	var solution : Dictionary = sav_data["solutions"][rec_op["solutions"]]

	# Get the sub-dictionary for inputs
	var inputs : Dictionary = solution["inputs"]

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
