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


# The name of the current level. When the player opens a level in the Chip
# Designer, this should be updated.
var current_level := "" setget set_current_level

# Solutions data for the current level.
var solutions : Dictionary


# Current solution to be updated. Should be updated when the user
# switches solutions.
var current_solution : String setget set_current_solution

# Inputs for the current selected solution
var inputs : Dictionary

# Outputs for the current selected solution
var outputs: Dictionary

# Chips in the curernt solution
var chips: Dictionary

# Wires in the current solution
var wires: Dictionary


# Set current level and load its data.
# If the level has no existing solutions, create one with the default
# name.
func set_current_level(level: String) -> bool:

	solutions = FileIO.load_leveldata(level)

	current_level = level

	return true



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
func move_input(input: String, pos: Vector2) -> void:
	inputs[input]["pos"] = [pos.x, pos.y]
	# TODO: queue appending action to recovery file


# set an output's x/y position
func move_output(output: String, pos: Vector2) -> void:
	outputs[output]["pos"] = [pos.x, pos.y]
	# TODO: queue appending action to recovery file


# add a chip at the given position
func add_chip(chip_id: int, chip_type: String, pos: Vector2) -> void:
	chips[chip_id] = { "type": chip_type, pos: [pos.x, pos.y] }
	# TODO: queue appending action to recovery file


# delete the chip specified from the current solution
func delete_chip(chip_id: int) -> void:
	chips.erase(chip_id)
	# TODO: queue appending action to recovery file


# set the position of the existing chip speicified
func move_chip(chip_id: int, pos: Vector2) -> void:
	chips[chip_id]["pos"] = [pos.x, pos.y]
	# TODO: queue appending action to recovery file


# add a wire segment at the given position
func add_segment(seg_id: int, wire_id: int, pos: Vector2) -> void:
	wires[wire_id][seg_id] = [pos.x, pos.y]
	# TODO: queue appending action to recovery file
