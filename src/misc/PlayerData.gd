# This script is a temporary place to implement some functions for handling
# player data. These can be used in whatever Scene/Node will be responsible
# for loading player solution data when opening a level.

# load_leveldata(level_name: String) -> Dictionary
# Currently, just a very simple function to at least illustrate the basic
# process I'm imagining for loading a player's saved data for a specified
# level.
func load_leveldata(level_name: String) -> Dictionary:

	var sav_data := load_savfile("user://" + level_name + ".sav")
	var rec_data := load_recfile("user://" + level_name + ".rec")

	update_from_rec(sav_data, rec_data)

	return sav_data


# load_savfile(file_name: String) -> Dictionary
# loads the data in a save file
func load_savfile(file_name: String) -> Dictionary:

	var sav_data := {}

	var file := File.new()
	var err := file.open_compressed(file_name, File.READ, File.COMPRESSION_ZSTD)
	if err != OK:
		# TODO: respond to Error stored in err appropriately
		return {"error": err}

	var parse_result : JSONParseResult = JSON.parse(file.get_as_text())
	file.close()

	if parse_result.error != OK:
		# TODO: Respond to Error stored in parse_result.error appropriately
		return {
			"error": parse_result.error,
			"error_string": parse_result.error_string
		}

	sav_data = parse_result.result

	return sav_data


# load_recfile(file_name: String) -> Array
# loads the data in a recovery file into an Array of the file's lines
func load_recfile(file_name: String) -> Array:
	var rec_data := []

	var file := File.new()
	var err := file.open(file_name, File.READ)
	if err != OK:
		# TODO: respond to Error stored in err appropriately
		return rec_data

	while (true):
		var line := file.get_line()
		if line:
			rec_data.append(line)
		else:
			break

	return rec_data


# write_savfile(file_name: String, level_data: Dictionary) -> int
# writes data from an appropriately formatted Dictionary to a savefile
func write_savfile(file_name: String, level_data: Dictionary) -> int:

	var file := File.new()
	var err := file.open_compressed(
		file_name,
		File.READ,
		File.COMPRESSION_ZSTD)
	if err != OK:
		return err

	var json : String = JSON.print(level_data)
	file.store_string(json)
	file.close()

	return OK


# update_from_rec(save_data: Dictionary, rec_data: Array) -> void
# Update a save data dictionary from an array of recovery file lines.
# returns an error code
func update_from_rec(sav_data: Dictionary, rec_data: Array) -> void:

	var err: int

	for line in rec_data:
		var rec_op = parse_json(line)
		var op_type = rec_op["op"]

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
		elif op_type == "add_wire":
			err = add_wire(sav_data, rec_op)
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


# move_input(sav_data: Dictionary, rec_op: Dictionary) -> int
# move an input's x/y position in sav_data as specified by rec_op,
# returning error code
func move_input(sav_data: Dictionary, rec_op: Dictionary) -> int:
	# Get the sub-dictionary for the particular solution being modified
	var solution : Dictionary = sav_data["solutions"][rec_op["solutions"]]

	# Get the sub-dictionary for inputs
	var inputs : Dictionary = solution["inputs"]

	inputs[rec_op["input"]] = rec_op["pos"]

	return OK
