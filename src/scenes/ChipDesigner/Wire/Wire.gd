tool
extends Node2D



var seg_grid := {}
var Segment: PackedScene=preload("res://scenes/ChipDesigner/Wire/WireSegment.tscn")

onready var segs : Node2D = $Segments

func add_seg_at(pos: Vector2) -> void:
	pass

func delete_seg_at(pos: Vector2) -> void:
	pass
