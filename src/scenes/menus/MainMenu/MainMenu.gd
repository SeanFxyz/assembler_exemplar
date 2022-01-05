extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()
	find_node("VersionLabel").text = Global.release_version


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	if get_tree().change_scene("res://scenes/menus/LevelMenu/LevelMenu.tscn") != OK:
		printerr("MainMenu: Scene change failed.")


func _on_QuitButton_pressed():
	get_tree().quit()
