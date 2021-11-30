extends Control

onready var canvas_switcher       := $CanvasSwitcher
onready var current_canvas        := $Canvas
onready var item_selected         := false
onready var mouse_moved_to_canvas := false
onready var selected_item         : String

var Dummy : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Dummy.tscn")
var Nand  : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Nand.tscn")
var Not   : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Not.tscn")
var And   : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/And.tscn")
var Or    : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Or.tscn")
var Xor   : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Xor.tscn")
var Mux   : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Mux.tscn")
var DMux  : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/DMux.tscn")
# TODO: Add the rest of the chips as PackedScene variables

var chip_scenes := {
	"Dummy Chip": Dummy,
	"Nand" : Nand,
	"Not"  : Not,
	"And"  : And,
	"Or"   : Or,
	"Xor"  : Xor,
	"Mux"  : Mux,
	"DMux" : DMux,
}

func _on_ItemList_item_selected(index):
	print_debug("ChipDesigner: item clicked")
	item_selected = true
	selected_item = $ItemListControl/ItemList.get_item_text(index)
	print(selected_item)


func _on_ItemList_nothing_selected():
	print_debug("ChipDesigner: nothing selected")
	item_selected = false


func _on_Canvas_mouse_on():
	if item_selected == true:
		item_selected = false
		current_canvas.add_chip_on_mouse(chip_scenes[selected_item])


func _on_test_control_pressed(control):
	pass # Replace with function body.


func _on_test_control_toggled(control, pressed):
	pass # Replace with function body.
