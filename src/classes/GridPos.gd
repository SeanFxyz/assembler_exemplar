# Grid position class. Represents a position in a grid.
class_name GridPos

# X position in the grid
var x : int

# Y position in the grid
var y : int


func _init(_x:int= 0, _y:int= 0, from=null) -> void:
	x = _x
	y = _y


func _to_string() -> String:
	return "[GridPos:(" + str(x) + ", " + str(y) + ")]"


# Returns the equivalent Vector2 position according to CanvasInfo's grid_inc
func to_vector2() -> Vector2:
	var offset := Vector2(CanvasInfo.grid_inc, CanvasInfo.grid_inc) / 2
	return Vector2(x, y) * CanvasInfo.grid_inc + offset


# Initializes GridPos from given Vector2 position
func from_vector2(v: Vector2) -> GridPos:
	var offset := CanvasInfo.grid_inc / 2
	x = v.x / CanvasInfo.grid_inc
	y = v.y / CanvasInfo.grid_inc
	return self


# Creates a unique numerical value corresponding to the current
# x and y values.
# First, maps x and y to positive values according to the following:
#     f(n) = 2n         if n >= 0
#     f(n) = -2n - 1    if n < 0
#
# Then, maps the resulting positive values to a single positive integer
# using the Cantor pairing function:
#     f(x, y) = (1/2)(x + y)(x + y + 1) + y
# http://en.wikipedia.org/wiki/Pairing_function#Cantor_pairing_function
func to_key() -> int:
	var a : int = 2 * x if x >= 0 else -2 * x - 1
	var b : int = 2 * y if y >= 0 else -2 * y - 1

	return int( 0.5 * (a + b) * (a + b + 1) + b )


# Initializes the GridPos x and y valuesfrom the given key value, effectively
# reversing the process performed by to_key().
# http://en.wikipedia.org/wiki/Pairing_function#Inverting_the_Cantor_pairing_function
func from_key(key: int) -> void:

	var w := floor( (sqrt(8 * key + 1) - 1) / 2 )
	var t := (w*w + w) / 2
	var b := int(key - t)
	var a := int(w - b)


	# warning-ignore:integer_division
	# warning-ignore:integer_division
	# warning-ignore:integer_division
	# warning-ignore:integer_division
	x = a / 2 if a % 2 == 0 else (a + 1) / -2
	y = b / 2 if b % 2 == 0 else (b + 1) / -2


# Returns a dictionary of grid positions adjacent to this position.
func get_neighbors() -> Dictionary:
	return {
		"left":  get_script().new(x - 1, y),
		"right": get_script().new(x + 1, y),
		"up":    get_script().new(x, y - 1),
		"down":  get_script().new(x, y + 1),
	}
