extends GridContainer
class_name ModularTab

#
# A "ModularTab" is a node that can be attached to a "Dock" (see Dock.gd)
# or be floating around freely and can be toggled.
#


var is_docked: bool setget set_docked
var button_down: bool
var currently_dragging: bool setget set_dragging
var drag_position: Vector2
var icon_path: String
var ui_element: Control

signal docked
signal undocked


func set_dragging(dragging: bool):
	currently_dragging = dragging
	if dragging:
		get_parent().active_tab = self
	else:
		get_parent().active_tab = null


func _ready() -> void:
	# Easy check if mouse is inside or not
	connect("docked", self, "on_dock")
	connect("undocked", self, "on_undock")
	
	ui_element = get_child(4)
	set_docked(get_parent() is Dock)
	
	$Button.text = self.name


func _input(input: InputEvent):
	if input is InputEventMouseButton:
		handle_mouse_button(input)
	elif input is InputEventMouseMotion:
		handle_mouse_motion(input)


# Set currently_dragging if it is not docked to a "Dock"
func handle_mouse_button(input: InputEventMouseButton, unhandled := false):
	if input.button_index == BUTTON_LEFT:
		if not is_docked:
			if $Button.is_mouse_inside:
				if not input.pressed: 
					button_down = false
					toggle_ui()
					set_dragging(false)
				# Only set dragging if the mouse is actually inside the control
				# or we will end up dragging it all the time
				else: 
					button_down = true
					drag_position = $Button.rect_global_position - input.global_position
					get_tree().set_input_as_handled()


# Drag the tab
func handle_mouse_motion(input: InputEventMouseMotion, unhandled := false):
	if button_down:
		set_dragging(true)
		rect_global_position = input.global_position + drag_position


func set_docked(docked: bool) -> void: 
	is_docked = docked
	emit_signal("docked") if docked else emit_signal("undocked")


func on_dock() -> void:
	$Button.visible = false
	$HSeparator.visible = false
	$VSeperator.visible = false
	$Spacer.visible = false
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
		$Button.pressed = !$Button.pressed
