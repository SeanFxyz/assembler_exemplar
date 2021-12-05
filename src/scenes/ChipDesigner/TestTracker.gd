extends Control

const header_fg_color := Color.gold
const active_bg_color := Color.white
const inactive_bg_color := Color.transparent
const head_items := 1

var icon_neutral : Texture = preload("res://images/test_icons/neutral.png")
var icon_bad     : Texture = preload("res://images/test_icons/bad.png")
var icon_good    : Texture = preload("res://images/test_icons/good.png")

var active_case : int = 0 setget set_active_case

var state_icons := {
	-1 : icon_bad,
	 0 : icon_neutral,
	 1 : icon_neutral,
}

var state_colors := {
	-1 : Color.crimson,
	 0 : Color.darkgray,
	 1 : Color.forestgreen,
}

onready var item_list := find_node("ItemList")

func populate(spec: ChipSpec) -> void:
	var header := ""
	for input_name in spec.input_names:
		header += "|" + input_name
	for output_name in spec.output_names:
		header += "|" + output_name
	header += "|"
	item_list.add_item(header, null, false)
	item_list.set_item_custom_fg_color(0, header_fg_color)
	
	for iset in spec.input_sets:
		var set_str := ""
		for input_name in spec.input_names:
			set_str += "|"
			var pad : int = input_name.length() - str(iset[input_name]).length()
			for _i in range(pad):
				set_str += " "
			set_str += str(iset[input_name])
		
		var oset := spec.get_outputs(iset)
		for output_name in spec.output_names:
			set_str += "|"
			var pad :int= output_name.length() - str(oset[output_name]).length()
			for _i in range(pad):
				set_str += " "
			set_str += str(oset[output_name])
		
		set_str += "|"
		
		item_list.add_item(set_str, null, false)
		item_list.set_item_custom_fg_color(
			item_list.get_item_count() - 1,
			state_colors[0]
		)
	
	item_list.select(0, true)


func set_case_state(index: int, state: int):
	# item_list.set_item_icon(index + 1, state_icons[state])
	item_list.set_item_custom_fg_color(index + head_items, state_colors[state])


func set_case_state_all(state: int):
	for i in range(item_list.get_item_count() - head_items):
		set_case_state(i, state)


func set_active_case(index: int):
	if active_case >= 0:
		item_list.set_item_custom_bg_color(active_case, inactive_bg_color)
	active_case = index + head_items
	if index >= 0:
		item_list.set_item_custom_bg_color(active_case, active_bg_color)
