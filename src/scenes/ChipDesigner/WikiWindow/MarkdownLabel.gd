extends RichTextLabel

# Keep track of whether or not we are in a code block
var in_code_block = false

# Keep track of whether or not we are in a paragraph
var in_paragraph = false

var md_text : String setget set_md_text

func set_md_text(value):
	md_text = value

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
			content = "[b][i][u]" + content + "[/u][/i][/b]"
		# Level 2 header
		if (hash_count == 2):
			content = "[b][i]" + content + "[/i][/b]"
		# Level 3 header
		if (hash_count == 3):
			content = "[b]" + content + "[/b]"

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
        value += "[code]"
        in_code_block = true

    # If at the end of a code block
    elif (in_code_block && value == "```"):
        # Remove "```" and end code block
        value.erase(0, 3)
        value += "[/code]"
        in_code_block = false

    # Return the string, altered or not
    return value

# Paragraph handling
func paragraph_handler(value : String) -> String:
    # If at the end of a paragraph, end it
    if (in_paragraph && value == "\n"):
        in_paragraph = false
    # If in a paragraph, but not at the end
    elif (in_paragraph):
        value = value.replace("\n", " ")

    return value

# Convert markdown to bbcode
func md_to_bb(value : String) -> String:
    # The returned string converted to bbcode
    var bb_string = ""

    # Make sure in_code_block starts as "false"
    in_code_block = false

	var md_lines = value.split('\n')
	for line in md_lines:
        if (in_code_block || line == "```"):
            bb_string +=  code_block_handler(line)
        else:
			if (line.begins_with("#")):
				bb_string += header_handler(line)
			# We are in normal paragraph if we reach this point
            else:
                in_paragraph = true
                bb_string += paragraph_handler(line)
        bb_string += "\n"
    return bb_string

# TESTING
func _ready():
	print(header_handler("arst"))
	print(header_handler("#    ars  it"))
	print(header_handler("##arst"))
	print(header_handler("###arstar#st #"))
    print(code_block_handler("```"))
    print(code_block_handler("arst"))
    print(code_block_handler("arst"))
    print(code_block_handler("arst"))
    print(code_block_handler("```"))
    in_paragraph = true
    print(paragraph_handler("arst arst arst\narst arst arst\narst arst arst"))
    print("\"" + paragraph_handler("\n") + "\"")
    print(in_paragraph)
    print(md_to_bb("#Test\n\n##Test\n\n###Test\n\n```\ntest test test\ntest " +
        "test test\n```\n\narst arst arst\narst arst arst\n\n"))
