extends GridContainer
class_name ModularTab

#
# A "ModularTab" is a node that can be attached to a "Dock" (see Dock.gd)
# or be floating around freely and can be toggled.
#


var is_docked: bool setget set_docked
var button_down: bool
var currently_dragging: bool
var drag_position: Vector2
var icon_path: String
var ui_element: Control

signal docked
signal undocked


func _ready() -> void:
	# Easy check if mouse is inside or not
	$Button.connect("button_up", self, "toggle_ui")
	connect("docked", self, "on_dock")
	connect("undocked", self, "on_undock")
	
	ui_element = get_child(4)
	set_docked(get_parent() is Dock)


func _input(input: InputEvent):
	if input is InputEventMouseButton:
		handle_mouse_button(input)
	elif input is InputEventMouseMotion:
		handle_mouse_motion(input)


# Set currently_dragging if it is not docked to a "Dock"
func handle_mouse_button(input: InputEventMouseButton):
	if input.button_index == BUTTON_LEFT:
		if not is_docked:
			if $Button.is_mouse_inside:
				if not input.pressed: button_down = false
				# Only set dragging if the mouse is actually inside the control
				# or we will end up dragging it all the time
				else: 
					button_down = true
					drag_position = $Button.rect_global_position - input.global_position


# Drag the tab
func handle_mouse_motion(input: InputEventMouseMotion):
	if button_down:
		currently_dragging = true
		rect_global_position = input.global_position + drag_position


func set_docked(docked: bool) -> void: 
	is_docked = docked
	emit_signal("docked") if docked else emit_signal("undocked")


func on_dock() -> void:
	$Button.visible = false
	ui_element.visible = true
	columns = 1


func on_undock() -> void: 
	$Button.visible = true
	ui_element.visible = false
	columns = 3


func toggle_ui():
	if not currently_dragging:
		ui_element.visible = !ui_element.visible
		$HSeparator.visible = !$HSeparator.visible
		$VSeperator.visible = !$VSeperator.visible
		$Spacer.visible = !$Spacer.visible
	else:
		currently_dragging = false
