extends HBoxContainer

signal test_control_pressed(control)
signal test_control_toggled(control, pressed)

onready var play := $PlayButton
onready var fast_forward := $FastForwardButton


func _on_ResetButton_pressed():
	play.set_pressed_no_signal(false)
	fast_forward.set_pressed_no_signal(false)
	emit_signal("test_control_pressed", "reset")


func _on_StepBackButton_pressed():
	play.set_pressed_no_signal(false)
	fast_forward.set_pressed_no_signal(false)
	emit_signal("test_control_pressed", "step_back")


func _on_StepForwardButton_pressed():
	play.set_pressed_no_signal(false)
	fast_forward.set_pressed_no_signal(false)
	emit_signal("test_control_pressed", "step_forward")


func _on_PlayButton_toggled(button_pressed):
	if button_pressed and fast_forward.pressed:
		fast_forward.pressed = false
	emit_signal("test_control_toggled", "play", button_pressed)


func _on_FastForwardButton_toggled(button_pressed):
	if button_pressed and play.pressed:
		play.pressed = false
	emit_signal("test_control_toggled", "fast_forward", button_pressed)
