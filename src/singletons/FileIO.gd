extends Node

# The FileIO singleton provides methods for storing player
# data on disk using Assembler Exemplar's score.json, *.sav, and *.rec
# file formats.


# If err == OK == 0, does nothing. Otherwise, prints err_msg and quits
# the application.
func _check_err(err: int, err_msg: String) -> void:
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
	_check_err(err, "Could not open rec file for appending.")

	file.seek_end()

	return file


# Get save file name for the given level name
func level_to_savfile(level_name: String) -> String:
	return _save_location + level_name + ".sav"


# Get recovery file name for the given level name
func level_to_recfile(level_name: String) -> String:
	return _save_location + level_name + ".rec"
	

# Load the sav file and rec file for a given level name.
# Sets sol_ref to point to a solutions dictionary and rec_ref to a
# recovery data array.
# Returns error code
func load_leveldata(level_name: String,
					sol_ref: Dictionary,
					rec_ref: Array) -> void:

	sol_ref = {}
	rec_ref = []
	
	# evaluate filenames for savfile and recfile
	var savfile_name := level_to_savfile(level_name)
	var recfile_name := level_to_recfile(level_name)

	# Check if savfile exists. If not, create a template file for the level.
	var file := File.new()
	if not file.file_exists(savfile_name):
		write_savfile(savfile_name, {})

	# Load sav data.
	sol_ref = load_savfile(savfile_name)

	# If rec file exists...
	if file.file_exists(recfile_name):
		# Load the rec file
		rec_ref = load_recfile(recfile_name)
		

func save_leveldata(level_name: String, solutions: Dictionary) -> void:
	# evaluate filenames for savfile and recfile
	var savfile_name := _save_location + level_name + ".sav"
	var recfile_name := _save_location + level_name + ".rec"


# loads the data in a save file
func load_savfile(file_name: String) -> Dictionary:

	var file := File.new()
	var err := file.open_compressed(file_name, File.READ, File.COMPRESSION_ZSTD)

	_check_err(err, "Could not load save file.")

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

	_check_err(err, "Could not read recfile.")
	if err == ERR_FILE_NOT_FOUND:
		return rec_data
	else:
		_check_err(err, "Could not read recfile.")

	while (true):
		var line := file.get_line()
		if line:
			rec_data.append(Marshalls.base64_to_variant(line))
		else:
			break

	return rec_data
