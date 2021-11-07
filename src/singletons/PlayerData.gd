extends Node

# The PlayerData singleton provides methods to access and modify player data.
# In the background, it will do the following:
#    * Maintain up-to-date player data within in-memory data structures
#      for fast access and modification.
#    * Append operations to the recovery file for the current level.
#    * Periodically update the current level's .sav file
#      (this should also clear the recovery file).


# The name to give a new solution created by the player.
# Must contain a %d placeholder, which will be replaced by a number
# when a new solution name is requested.
var new_solution_base_name := "Solution %d"


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
func set_current_level(new_value: String) -> void:
	var rec_data : Array
	FileIO.load_leveldata(new_value, solutions, rec_data)

	current_level = new_value


# Sets the current solution and updates relevant references accordingly.
func set_current_solution(new_value: String) -> void:
	current_solution = new_value

	if not solutions.has(current_solution):
		create_solution(current_solution)

	inputs  = solutions[current_solution]["inputs"]
	outputs = solutions[current_solution]["outputs"]
	chips   = solutions[current_solution]["chips"]
	wires   = solutions[current_solution]["wires"]


func _ready():
	pass


func new_solution_name():
	if (solutions):
		var new_solution_num := 1 
		var new_solution_name := new_solution_base_name % new_solution_num
		for sol in solutions:
			if new_solution_name == sol:
				new_solution_num += 1
				new_solution_name = new_solution_base_name % new_solution_num
		return new_solution_base_name % new_solution_num
	else:
		return "solution"


func save() -> void:
	pass


# Create a new solution for the current level.
func create_solution(new_name: String) -> bool:
	if solutions.has(new_name):
		return false
	else:
		solutions[new_name] = _solution_template.duplicate()
		return true


# Rename a solution for the current level.
func rename_solution(old_name: String, new_name: String) -> bool:
	# TODO: check that the name doesn't already exist
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
