tool
extends Control

export var head_text   := "Info Panel" setget set_head_text
export(String, MULTILINE) var body_text : String setget set_body_text

onready var is_ready := true
onready var head     := $Head
onready var body     := $MarkdownLabel


func set_head_text(new_value: String) -> void:
	head_text = new_value
	if is_ready:
		head.text = new_value
	

func set_body_text(new_value: String) -> void:
	body_text = new_value
	if is_ready:
		body.md_text = new_value
