extends RichTextLabel

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

# Convert markdown to bbcode
func md_to_bb(value : String):
    # Keep track of whether or not we are in a code block
    var in_code_block = false

	var md_lines = value.split('\n')
	for line in md_lines:
        if (line == "```"):
            in_code_block = not in_code_block
        # elif (in_code_block):
        #     code_block_handler(line)
        elif (!in_code_block):
            if (line[0] == "#"):
                header_handler(line)
            # We are in normal paragraph if we reach this point
            # else:
            #     paragraph_handler(line)

func _ready():
	print(header_handler("arst"))
	print(header_handler("#    ars  it"))
	print(header_handler("##arst"))
	print(header_handler("###arstar#st #"))
