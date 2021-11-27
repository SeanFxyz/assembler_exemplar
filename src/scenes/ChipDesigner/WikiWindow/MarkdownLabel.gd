tool
extends RichTextLabel

# Keep track of whether or not we are in a code block
var in_code_block = false

export(String, MULTILINE) var md_text := "# Hello World" setget set_md_text

func set_md_text(value):
	md_text = value
	bbcode_text = md_to_bb(md_text)

# Determines type of header, returns bbcode representation
func header_handler(content : String) -> String:
	# Count the number of hashes
	var hash_count = 0

	# Make sure header_handler(content) was called correctly
	if (content[0] == "#"):

		# Count only the leading hashes
		for character in content:
			if (character != "#"):
				break
			hash_count += 1

		# Remove leading hashes and leading whitespace from content
		content.erase(0, hash_count)
		content = content.dedent()

		# Determine what level of header content should be
		# Level 1 header
		if (hash_count == 1):
			content = "[font=res://Fonts/Level1Header.tres]" + content + "[/font]"
		# Level 2 header
		if (hash_count == 2):
			content = "[font=res://Fonts/Level2Header.tres]" + content + "[/font]"
		# Level 3 header
		if (hash_count == 3):
			content = "[font=res://Fonts/Level3Header.tres]" + content + "[/font]"

		return content
	else:
		print("header_handler(content) called incorrectly")
		return "--- DID NOT WORK --- DID NOT WORK --- DID NOT WORK ---"

# Code block handling
func code_block_handler(value : String) -> String:
	# If at the start of a code block
	if (!in_code_block && value == "```"):
		# Remove "```" and start code block
		value.erase(0, 3)
		value += "[code][color=silver]"
		in_code_block = true

	# If at the end of a code block
	elif (in_code_block && value == "```"):
		# Remove "```" and end code block
		value.erase(0, 3)
		value += "[/color][/code]"
		in_code_block = false

	# Return the string, altered or not
	return value

# TODO: Finish o_list_handler
# func o_list_handler(value : String) -> String:
#     # Check if it is a single-digit number
#     if (int(line.substr(0, 1)) && line.substr(1, 2) == " "):

#     # If not, check if it is a double-digit number
#     elif (int(line.substr(0, 2)) && line.substr(2, 3) == " ")):

#     # Indent the list
#     value = "[indent]" + value + "[indent]"

#     return value

func uo_list_handler(value : String) -> String:
	# Make the unordered list identifier (* or -) bold
	value = value.replace("* ", "• ")
	value = value.insert(0, "[b]")
	value = value.insert(4, "[/b]")
	# Indent the list
	value = "[indent]" + value + "[/indent]"

	return value

# Convert markdown to bbcode
func md_to_bb(value : String) -> String:
	# The returned string converted to bbcode
	var bb_string = ""

	# Make sure in_code_block starts as "false"
	in_code_block = false

	var md_lines = value.split('\n')
	for line in md_lines:
		# Check if code block
		if (in_code_block || line == "```"):
			bb_string +=  code_block_handler(line)
			# Put the "\n" back in
			bb_string += "\n"
		else:

			# Check if header
			if (line.begins_with("#")):
				bb_string += header_handler(line)
				# Put the "\n" back in
				bb_string += "\n"

			# TODO: Finish o_list_handler
			# # Check if ordered list
			# # First check if it is a single-digit number
			# elif ((int(line.substr(0, 1)) && line.substr(1, 2) == " ") ||
			#         # Next check if it is a double-digit number
			#         (int(line.substr(0, 2)) && line.substr(2, 3) == " ")):

			#     bb_string += o_list_handler(line)
			#     # Put the "\n" back in
			#     bb_string += "\n"

			# Check if unordered list
			elif (line.begins_with("* ") || line.begins_with("- ")):
				bb_string += uo_list_handler(line)
				# Put the "\n" back in
				bb_string += "\n"

			# Check if blank line
			elif (line == ""):
				bb_string += "\n"

			# We are in normal paragraph if we reach this point
			else:
				bb_string += line + " "
				bb_string += "\n"
	# Remove any trailing whitespace
	bb_string = bb_string.replace(" \n", "\n")

	# TODO: Check bb_string for italics in md, then add them in bb_code

	return bb_string

# TESTING
func _ready():
	print_debug(header_handler("arst"))
	print_debug(header_handler("#    ars  it"))
	print_debug(header_handler("##arst"))
	print_debug(header_handler("###arstar#st #"))
	print_debug(code_block_handler("```"))
	print_debug(code_block_handler("arst"))
	print_debug(code_block_handler("arst"))
	print_debug(code_block_handler("arst"))
	print_debug(code_block_handler("```"))
	print_debug(md_to_bb("arst arst arst\narst arst arst\n\n#Test\n\n##Test\n\n###Test\n\n```\ntest test test\ntest test test\n```\n\narst arst arst\narst arst arst\n\narst arst arst\n\n* test of unordered list"))
