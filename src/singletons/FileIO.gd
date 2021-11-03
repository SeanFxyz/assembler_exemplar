extends Node

# The FileIO singleton provides methods for storing player
# data on disk using Assembler Exemplar's score.json, *.sav, and *.rec
# file formats.


# If err == OK == 0, does nothing. Otherwise, prints err_msg and quits
# the application.
func _check_err(err_msg: String, err: int) -> void:
	if err != OK:
		print(err_msg)
		get_tree().quit()


# The path to the player's scorefile.
var _scorefile_name := "user://score.json"

# The location where .sav and .rec files are stored.
var _save_location  := "user://save/"


# If we have opened a .rec file for appending, this holds a reference to it.
var _recfile : File


# Serialize and append recdata to the currently open recovery file.
func append_recdata(recdata: Dictionary) -> int:
	if _recfile:
		_recfile.store_line(Marshalls.variant_to_base64(recdata))
		return OK

	return FAILED


# opens rec file for the level for appending
func open_recfile(level_name: String) -> File:

	var file := File.new()

	var file_name := _save_location + level_name + ".rec"

	var err := file.open(file_name, File.READ_WRITE)
	_check_err("Could not open rec file for appending.", err)

	file.seek_end()

	return file


# Load the sav file for a given level name and return the level's
# save data.
func load_leveldata(level_name: String) -> Dictionary:

	# evaluate filenames for savfile and recfile
	var savfile_name := _save_location + level_name + ".sav"
	var recfile_name := _save_location + level_name + ".rec"

	# Check if savfile exists. If not, create a template file for the level.
	var file := File.new()
	if not file.file_exists(savfile_name):
		write_savfile(savfile_name, {})

	# Load sav data.
	var solutions := load_savfile(savfile_name)

	# If rec file exists...
	if file.file_exists(recfile_name):

		# Load the rec file
		var rec_data := load_recfile(recfile_name)

		# Update loaded level data from the recfile.
		var err := update_from_rec(sav_data, rec_data)
		_check_err("Unable to update from loaded rec file", err)

	return solutions


# loads the data in a save file
func load_savfile(file_name: String) -> Dictionary:

	var file := File.new()
	var err := file.open_compressed(file_name, File.READ, File.COMPRESSION_ZSTD)

	_check_err("Could not load save file.", err)

	var solutions: Dictionary = Marshalls.base64_to_variant(file.get_as_text())
	file.close()

	return solutions


# writes data from an appropriately formatted Dictionary to a savefile
func write_savfile(file_name: String, level_data: Dictionary) -> int:

	var file := File.new()
	var err := file.open_compressed(
		file_name,
		File.READ,
		File.COMPRESSION_ZSTD)

	if err == OK:
		file.store_string(Marshalls.variant_to_base64(level_data))

	if file.is_open():
		file.close()

	return err


# loads the data in a recovery file into an Array of the file's lines
func load_recfile(file_name: String) -> Array:
	var rec_data := []

	var file := File.new()
	var err := file.open(file_name, File.READ)

	_check_err("Could not read recfile.", err)
	if err == ERR_FILE_NOT_FOUND:
		return rec_data
	else:
		_check_err("Could not read recfile.", err)

	while (true):
		var line := file.get_line()
		if line:
			rec_data.append(Marshalls.base64_to_variant(line))
		else:
			break

	return rec_data


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
