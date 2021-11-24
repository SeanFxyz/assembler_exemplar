extends Area2D

# Where to implement inputs
var snap_inc := CanvasInfo.grid_inc

export var chip_type := ""

# Unique chip ID
onready var chip_id : int = PlayerData.next_chip_id()


onready var sprite_rect : Rect2 = $Sprite.get_rect()

# Called when the node enters the scene tree for the first time.
func _ready():
	if connect("input_event", self, "_on_Drag") != OK:
		printerr("CanvasChip: failed to connect signal: input_event")
	if connect("mouse_entered", self, "_on_mouse_entered") != OK:
		printerr("CanvasChip: failed to connect signal: mouse_entered")
	if connect("mouse_exited", self, "_on_mouse_exited") != OK:
		printerr("CanvasChip: failed to connect signal: mouse_exited")


var prev_mouse_position = Vector2()
var is_dragged = false

func _on_Drag(_viewport, event, _shape_idx):
	# Allow dragging if user clicks CollisionShape2D
	if event.is_action_pressed("ui_select"):
		get_tree().set_input_as_handled()
		prev_mouse_position = event.position
		is_dragged = true
		CanvasInfo.chips_dragged += 1
		
func _on_mouse_entered():
	CanvasInfo.entities_hovered += 1

func _on_mouse_exited():
	CanvasInfo.entities_hovered -= 1
		
func _input(event):
	# Disable dragging if click is released
	if not is_dragged:
		return
	
	if event.is_action_released("ui_select"):
		prev_mouse_position = Vector2()
		is_dragged = false
		CanvasInfo.chips_dragged -= 1
		# Snap to grid
		position = position.snapped(Vector2(snap_inc, snap_inc))
	
	if is_dragged and event is InputEventMouseMotion:
		position += (event.position - prev_mouse_position) * CanvasInfo.zoom_cur
		prev_mouse_position = event.position
