tool
extends Control

export var head_text   : String setget set_head_text
export var body_text : String setget set_body_text

onready var head := $Head
onready var body := $MarkdownLabel


func set_head_text(new_value: String) -> void:
	head_text = new_value
	head.text = new_value
	

func set_body_text(new_value: String) -> void:
	body_text = new_value
	body.md_text = new_value
