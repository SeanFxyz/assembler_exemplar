extends Node

# The PlayerData singleton provides methods to access and modify player data.
# In the background, it will do the following:
#    * Maintain up-to-date player data within in-memory data structures
#      for fast access and modification.
#    * Abstract saving and loading player solution data.


var _player_scores : Dictionary

# The name to give a new solution created by the player.
# Must contain a %d placeholder, which will be replaced by a number
# when a new solution name is requested.
var _new_solution_base_name := "Solution %d"


# template structure for player solutions
var _solution_template := {
	"inputs": {},
	"outputs": {},
	"chips": [],
	"wires": [],
	"score": 0,
}


# The name of the current level. When the player opens a level in the Chip
# Designer, this should be updated.
var current_level := "" setget set_current_level


# Solutions data for the current level.
var solutions : Dictionary = {}


# Current solution to be updated. Should be updated when the user
# switches solutions.
var current_solution : String setget set_current_solution

# Current solution dictionary
var cur_solution_data : Dictionary

# Inputs for the current selected solution
var inputs : Dictionary

# Outputs for the current selected solution
var outputs: Dictionary

# Chips in the curernt solution
var chips: Array

# Wires in the current solution
var wires: Array


func _ready() -> void:
	_player_scores = FileIO.load_player_scores()


func get_player_score(level: String) -> int:
	if _player_scores.has(level):
		return _player_scores[level]
	return 0


func set_player_score(level: String, new_value: int) -> void:
	_player_scores[level] = new_value
	FileIO.save_player_scores(_player_scores)


func get_player_grade(level: String) -> String:
	var score := get_player_score(level)
	var percent : float
	if score == 0:
		percent = 0
	else:
		percent = float(ChipIO.chip_specs[level].nands) / score * 100.0
		if percent > 100:
			percent = 0
	
	return str(percent) + "%"


# Set current level and load its data.
# If the level has no existing solutions, create one with the default
# name.
# Select the first solution.
func set_current_level(new_value: String) -> void:
	current_level = new_value
	
	_solution_template = ChipIO.chip_specs[new_value].make_solution_template()
	
	solutions = FileIO.load_leveldata(new_value)
	if solutions.empty():
		create_solution()
	
	set_current_solution(solutions.keys()[0])


# Sets the current solution and updates relevant references accordingly.
func set_current_solution(new_value: String) -> void:
	if solutions.has(new_value):
		current_solution = new_value
	else:
		current_solution = create_solution(new_value)
	update_refs()


# Update the values of the following references:
#   - inputs
#   - outputs
#   - chips
#   - wires
#   - score
func update_refs():
	cur_solution_data = solutions[current_solution]
	inputs  = cur_solution_data["inputs"]
	outputs = cur_solution_data["outputs"]
	chips   = cur_solution_data["chips"]
	wires   = cur_solution_data["wires"]


func next_solution_name() -> String:
	var new_solution_num := 1
	var new_solution_name := _new_solution_base_name % new_solution_num
	for sol in solutions:
		if new_solution_name == sol:
			new_solution_num += 1
			new_solution_name = _new_solution_base_name % new_solution_num
	return _new_solution_base_name % new_solution_num


func fix_solution_name(name: String) -> String:
	var num := 1
	var new_name := name
	while solutions.has(new_name):
		new_name = name + "(" + str(num) + ")"
		num += 1
	
	return new_name


func update_solution(solution: String, data: Dictionary) -> void:
	solutions[solution] = data
	update_refs()


# Update the current_solution with provided solution data
func update_current_solution(data) -> void:
	solutions[current_solution] = data
	update_refs()


# Triggers save for current level
func save() -> void:
	FileIO.save_leveldata(current_level, solutions)


# Create a new solution for the current level, returning the final name of the
# created solution.
func create_solution(new_name:= "") -> String:
	var solution_name : String
	
	if new_name != "":
		solution_name = fix_solution_name(new_name)
	else:
		solution_name = next_solution_name()
		
	solutions[solution_name] = ChipIO.chip_specs[current_level].make_solution_template()
	return solution_name


# Rename a solution for the current level.
func rename_solution(old_name: String, new_name: String) -> bool:
	# TODO: check that the name doesn't already exist
	solutions[new_name] = solutions[old_name].duplicate(true)
	if current_solution == old_name:
		set_current_solution(new_name)
	# warning-ignore:return_value_discarded
	solutions.erase(old_name)

	return true


# Delete a solution for the current level.
func delete_solution(sol_name: String) -> bool:
	# If the current solution is the one to be deleted, change
	# it to the first solution.
	if current_solution == sol_name:
		set_current_solution(solutions.keys()[0])

	# warning-ignore:return_value_discarded
	solutions.erase(sol_name)

	return true


# set an input's x/y position
func move_input(input: String, pos: Vector2) -> void:
	inputs[input]["pos"] = pos


# set an output's x/y position
func move_output(output: String, pos: Vector2) -> void:
	outputs[output]["pos"] = pos


# add a chip at the given position
func add_chip(chip_id: int, chip_type: String, pos: Vector2) -> void:
	chips[chip_id] = { "type": chip_type, pos: pos }


# delete the chip specified from the current solution
func delete_chip(chip_id: int) -> void:
	# warning-ignore:return_value_discarded
	chips.erase(chip_id)


# set the position of the existing chip speicified
func move_chip(chip_id: int, pos: Vector2) -> void:
	chips[chip_id]["pos"] = pos


# add a wire segment at the given position
func add_segment(seg_id: int, wire_id: int, pos: Vector2) -> void:
	wires[wire_id][seg_id] = pos
