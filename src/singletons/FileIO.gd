extends Node

# The FileIO singleton provides methods for storing player
# data on disk using Assembler Exemplar's score.json, *.sav, and *.rec
# file formats.


func _ready() -> void:
	var dir := Directory.new()
	if not dir.dir_exists("user://save"):
		assert(dir.make_dir("user://save") == OK)


# The path to the player's scorefile.
const _scorefile_name := "user://score.json"

# The location where .sav and .rec files are stored.
const _save_location  := "user://save/"


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

	assert(file.open(file_name, File.READ_WRITE) == OK)

	file.seek_end()

	return file


# Get save file name for the given level name
func level_to_savfile(level_name: String) -> String:
	return _save_location + level_name + ".sav"


# Get recovery file name for the given level name
func level_to_recfile(level_name: String) -> String:
	return _save_location + level_name + ".rec"


func load_player_scores() -> Dictionary:
	var file := File.new()
	if not file.file_exists(_scorefile_name):
		return {}
	assert(file.open(_scorefile_name, File.READ) == OK)
	return Marshalls.base64_to_variant(file.get_as_text())


func save_player_scores(scores: Dictionary) -> void:
	var file := File.new()
	assert(file.open(_scorefile_name, File.WRITE) == OK)
	file.store_string(Marshalls.variant_to_base64(scores))


# Load the saved data for a given level name.
func load_leveldata(level_name: String) -> Dictionary:

	var solutions : Dictionary
	
	# evaluate filenames for savfile and recfile
	var savfile_name := level_to_savfile(level_name)

	# Check if savfile exists. If not, create a template file for the level.
	var file := File.new()
	if not file.file_exists(savfile_name):
		write_savfile(savfile_name, {})

	# Load sav data.
	solutions = load_savfile(savfile_name)
	
	return solutions
		

# Save the given solutions data to the save file for the names level
func save_leveldata(level_name: String, solutions: Dictionary) -> void:
	var savfile_name := level_to_savfile(level_name)
	write_savfile(savfile_name, solutions)


# loads the data in a save file
func load_savfile(file_name: String) -> Dictionary:
	var file := File.new()
	assert(
		file.open_compressed(file_name, File.READ, File.COMPRESSION_ZSTD) == OK
	)

	var solutions: Dictionary = Marshalls.base64_to_variant(file.get_as_text())
	file.close()

	return solutions


# writes data Dictionary to the specified savfile
func write_savfile(file_name: String, data: Dictionary) -> void:

	var file := File.new()
	assert(
		file.open_compressed(file_name, File.WRITE, File.COMPRESSION_ZSTD) == OK
	)

	file.store_string(Marshalls.variant_to_base64(data))
	file.close()


# loads the data in a recovery file into an Array of the file's lines
func load_recfile(file_name: String) -> Array:
	var rec_data := []

	var file := File.new()
	
	if not file.file_exists(file_name):
		return rec_data
	
	assert(file.open(file_name, File.READ) == OK)

	while (true):
		var line := file.get_line()
		if line:
			rec_data.append(Marshalls.base64_to_variant(line))
		else:
			break

	return rec_data
