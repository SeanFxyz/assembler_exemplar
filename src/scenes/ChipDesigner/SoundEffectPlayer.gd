extends AudioStreamPlayer

var effects := {
	"blip": preload("res://sounds/bloop2.wav"),
	"bloop": preload("res://sounds/bloop1.wav"),
	"oneup": preload("res://sounds/oneup1.wav"),
}

func play_effect(eff: String) -> void:
	stream = effects[eff]
	play()
