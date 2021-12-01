extends Control

# test speeds in tests per second
const TEST_SPEED := 1
const TEST_SPEED_FAST := 2

var test_index       : int = -1
var test_successes   : Dictionary 
var test_chip_spec   : ChipSpec
var test_initialized := false
var test_paused      := true
var test_timer       : Timer

var item_selected := false
var selected_item : String

onready var canvas_switcher := $CanvasSwitcher
onready var current_canvas  := $Canvas
onready var test_tracker    := find_node("TestTracker")

var Dummy : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Dummy.tscn")
var Nand  : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Nand.tscn")
var Not   : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Not.tscn")
var And   : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/And.tscn")
var Or    : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Or.tscn")
var Xor   : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Xor.tscn")
var Mux   : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/Mux.tscn")
var DMux  : PackedScene = preload("res://scenes/ChipDesigner/CanvasChips/DMux.tscn")

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


func _ready() -> void:
	test_timer = Timer.new()
	test_timer.paused = true
	test_timer.connect("timeout", self, "_on_test_timer_timeout")
	test_chip_spec = ChipIO.chip_specs[PlayerData.current_level]
	test_tracker.populate(test_chip_spec)


func play_test(speed: int) -> void:
	
	if test_initialized:
		test_timer.wait_time = 1 / speed
		test_timer.paused = false
		test_paused = false
	else:
		initialize_test()
		test_forward()
		
		test_timer.wait_time = 1 / speed
		test_timer.paused = false
		test_timer.start()
		test_paused = false


func pause_test() -> void:
	test_timer.paused = true
	test_paused = true


func initialize_test() -> void:
	pause_test()
	test_index = -1
	test_initialized = true
	test_tracker.set_case_state_all(0)


func test_forward() -> void:
	if not test_initialized:
		initialize_test()
	test_index = min(test_index + 1, test_chip_spec.input_sets.size() - 1)
	current_canvas.set_input_values(test_chip_spec.input_sets[test_index])
	check_test_values()


func test_back() -> void:
	if not test_initialized:
		initialize_test()
	test_index = max(test_index - 1, 0)
	current_canvas.set_input_values(test_chip_spec.input_sets[test_index])
	check_test_values()


func check_test_values() -> void:
	var test_inputs  : Dictionary = current_canvas.get_input_values()
	var test_outputs : Dictionary = current_canvas.get_output_values()
	
	test_tracker.set_active_case(test_index)
	
	var test_key = test_chip_spec.format_input(test_inputs)
	if compare_io(test_chip_spec.io[test_key], test_outputs):
		test_part_success()
	else:
		test_part_fail()


func test_part_success() -> void:
	print("test_part_success")
	test_successes[test_index] = true
	test_tracker.set_case_state(test_index, 1)


func test_part_fail() -> void:
	print("test_part_fail")
	test_successes[test_index] = true
	test_tracker.set_case_state(test_index, -1)


func compare_io(d1: Dictionary, d2: Dictionary) -> bool:
	for k in d1.keys():
		if d2.has(k) == false or d1[k] != d2[k]:
			return false
	return true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		exit_chip_designer()


func exit_chip_designer() -> void:
	get_tree().change_scene("res://scenes/LevelMenu/LevelMenu.tscn")


func _on_test_timer_timeout() -> void:
	test_forward()


func _on_ItemList_item_selected(index) -> void:
	print_debug("ChipDesigner: item clicked")
	item_selected = true
	selected_item = $ItemListControl/ItemList.get_item_text(index)
	print(selected_item)


func _on_ItemList_nothing_selected() -> void:
	print_debug("ChipDesigner: nothing selected")
	item_selected = false


func _on_Canvas_mouse_on() -> void:
	if item_selected == true:
		item_selected = false
		current_canvas.add_chip_on_mouse(chip_scenes[selected_item])


func _on_test_control_pressed(control) -> void:
	if control == "reset":
		initialize_test()
	elif control == "step_back":
		pause_test()
		test_back()
	elif control == "step_forward":
		pause_test()
		test_forward()


func _on_test_control_toggled(control, pressed) -> void:
	if pressed:
		play_test(TEST_SPEED if control == "play" else TEST_SPEED_FAST)
	else:
		pause_test()


func _on_Canvas_save_requested(solution_data):
	PlayerData.solutions[PlayerData.current_solution] = solution_data
	PlayerData.save()
