extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer2/Button_Chip1.grab_focus()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_Chip1_pressed():
	## Function to Send user to design chip 1 ()
	pass # Replace with function body.



func _on_Button_pressed():
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")

