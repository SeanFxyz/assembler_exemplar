# This script is a temporary place to implement some functions for handling
# player data. These can be used in whatever Scene/Node will be responsible
# for loading player solution data when opening a level.

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
