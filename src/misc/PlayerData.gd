# This script is a temporary place to implement some functions for handling
# player data. These can be used in whatever Scene/Node will be responsible
# for loading player solution data when opening a level.

func load_level_data(level_name: String) -> Dictionary:
	var level_data := {}
	
	var file := File.new()
	var err := file.open_compressed(
		"user://solutions/" + level_name,
		File.READ,
		File.COMPRESSION_ZSTD)
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
	
	level_data = parse_result.result
	# TODO: read recovery file, if exists, and update level data
	
	return level_data

func write_level_data(level_name: String, level_data: Dictionary) -> int:
	
	var file := File.new()
	var err := file.open_compressed(
		"user://solutions/" + level_name,
		File.READ,
		File.COMPRESSION_ZSTD)
	if err != OK:
		return err
	
	var json : String = JSON.print(level_data)
	file.store_string(json)
	file.close()
	
	return OK
