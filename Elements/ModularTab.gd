extends Control
class_name ModularTab

var is_mouse_inside setget set_mouse_inside
var currently_dragging: bool
var icon_path: String


func _ready():
	connect("mouse_entered", self, "set_mouse_inside", [true])
	connect("mouse_exited", self, "set_mouse_inside", [false])


func set_mouse_inside(is_inside: bool):
	is_mouse_inside = is_inside


func _input(input: InputEvent):
	if input is InputEventMouseButton:
		handle_mouse_button(input)
	elif input is InputEventMouseMotion:
		handle_mouse_motion(input)


func handle_mouse_button(input: InputEventMouseButton):
	if input.button_index == BUTTON_LEFT:
		if not is_docked():
			if not input.pressed: currently_dragging = false
			if input.pressed: if is_mouse_inside: currently_dragging  = true


func handle_mouse_motion(input: InputEventMouseMotion):
	if currently_dragging: 
		rect_global_position = input.global_position


func is_docked() -> bool: return get_parent() is Dock
