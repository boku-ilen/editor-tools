extends Control
class_name ModularTab

#
# A "ModularTab" is a node that can be attached to a "Dock" (see Dock.gd)
# or be floating around freely and can be toggled.
#


var is_mouse_inside setget set_mouse_inside
var currently_dragging: bool
var icon_path: String


func _ready() -> void:
	# Easy check if mouse is inside or not
	connect("mouse_entered", self, "set_mouse_inside", [true])
	connect("mouse_exited", self, "set_mouse_inside", [false])


func set_mouse_inside(is_inside: bool) -> void:
	is_mouse_inside = is_inside


func _input(input: InputEvent):
	if input is InputEventMouseButton:
		handle_mouse_button(input)
	elif input is InputEventMouseMotion:
		handle_mouse_motion(input)


# Set currently_dragging if it is not docked to a "Dock"
func handle_mouse_button(input: InputEventMouseButton):
	if input.button_index == BUTTON_LEFT:
		if not is_docked():
			if not input.pressed: currently_dragging = false
			# Only set dragging if the mouse is actually inside the control
			# or we will end up dragging it all the time
			else: if is_mouse_inside: currently_dragging  = true


# Drag the tab
func handle_mouse_motion(input: InputEventMouseMotion):
	if currently_dragging: 
		rect_global_position = input.global_position


func is_docked() -> bool: return get_parent() is Dock
