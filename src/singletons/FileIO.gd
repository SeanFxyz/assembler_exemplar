extends Node


var _scorefile_name := "user://score.json"
var _save_location  := "user://save/"


# Currently, just a very simple function to at least illustrate the basic
# process I'm imagining for loading a player's saved data for a specified
# level.
func load_leveldata(level_name: String) -> Dictionary:

	var sav_data := load_savfile("user://save/" + level_name + ".sav")
	var rec_data := load_recfile("user://save/" + level_name + ".rec")

	update_from_rec(sav_data, rec_data)

	return sav_data


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


# Update a save data dictionary from an array of recovery file lines.
# returns an error code
func update_from_rec(sav_data: Dictionary, rec_data: Array) -> void:

	var err := OK

	for line in rec_data:
		var rec_op : Dictionary = parse_json(line)
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
