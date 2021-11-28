tool
extends Control

export(String, MULTILINE) var text : String setget set_text

onready var is_ready := true
onready var body     := $MarkdownLabel

func set_text(new_value: String) -> void:
	text = new_value
	if is_ready:
		body.md_text = new_value
