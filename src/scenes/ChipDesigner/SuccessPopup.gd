extends Popup

onready var grade_label := find_node("GradeValueLabel")

func _on_about_to_show():
	grade_label.text = (PlayerData.get_player_grade(PlayerData.current_level))
