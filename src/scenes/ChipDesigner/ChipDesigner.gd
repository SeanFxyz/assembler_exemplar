extends Control

onready var canvas_switcher := $CanvasSwitcher
onready var current_canvas := $Canvas
onready var item_selected := false
onready var mouse_moved_to_canvas := false
onready var selected_item : String

var Dummy:PackedScene=preload("res://scenes/ChipDesigner/CanvasChips/Dummy.tscn")
var Nand:PackedScene=preload("res://scenes/ChipDesigner/CanvasChips/Nand.tscn")
var Not:PackedScene=preload("res://scenes/ChipDesigner/CanvasChips/Not.tscn")
# TODO: Add the rest of the chips as PackedScene variables

var chip_scenes := {
	"Dummy Chip": Dummy,
	"Nand": Nand,
	"Not":  Not,
}

func _on_ItemList_item_selected(index):
	print("item clicked")
	item_selected = true
	selected_item = $ItemListControl/ItemList.get_item_text(index)
	print(selected_item)

func _on_ItemList_nothing_selected():
	print("nothing selected")
	item_selected = false

func _on_Canvas_mouse_on():
	if item_selected == true:
		item_selected = false
		current_canvas.add_chip(chip_scenes[selected_item])
