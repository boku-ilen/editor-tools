extends TabContainer
class_name Dock

#
# A "dock" is a tabcontainer to/from which one can drag and drop "ModularTabs"
# (see ModularTab.gd/.tscn). It will not be visible if it has no children.
#


var main_ui: Control
var currently_dragging: bool = false
var is_inside_tab_bar: bool = false
# If the visibility changes, also message the "Side" (see Side.gd)
signal state_changed(active)


func _ready() -> void:
	connect("resized", self, "set_collider_size")
	check_visibility()


func _input(input: InputEvent) -> void:
	if input is InputEventMouseButton:
		handle_mouse_button(input)
	if input is InputEventMouseMotion:
		handle_mouse_motion(input)


func _unhandled_input(input: InputEvent):
	if input is InputEventMouseButton:
		handle_mouse_button(input, true)
	elif input is InputEventMouseMotion:
		handle_mouse_motion(input, true)
		

func handle_mouse_button(input: InputEventMouseButton, unhandled := false) -> void:
	if input.button_index == BUTTON_LEFT:
		if input.pressed == false:
			currently_dragging = false
			if is_inside_tab_bar:
				if main_ui.floating_ui.get_child_count():
					for child in main_ui.floating_ui.get_children():
						if is_inside_tab_bar(child.rect_global_position) and visible:
							main_ui.floating_ui.remove_child(child)
							child.is_docked = true
							add_child(child)
		else: 
			if is_inside_tab_bar: 
				currently_dragging = true


func handle_mouse_motion(input: InputEventMouseMotion, unhandled := false) -> void:
	if not is_inside_tab_bar(input.global_position):
		is_inside_tab_bar = false
		if currently_dragging:
			var modular_tab = get_tab_control(current_tab)
			if modular_tab:
				remove_child(modular_tab)
				main_ui.floating_ui.add_child(modular_tab)
				modular_tab.button_down = true
				modular_tab.is_docked = false
				currently_dragging = false
	else: 
		is_inside_tab_bar = true


# Check if a specific position is inside the small bar of a dock, where the 
# individual tabs are visualized
func is_inside_tab_bar(position: Vector2) -> bool:
	var global_tab_bar_extent = rect_global_position + Vector2(rect_size.x, 23) 
	if position.x < rect_global_position.x or position.y < rect_global_position.y:
		return false
	if position.x > global_tab_bar_extent.x or position.y > global_tab_bar_extent.y:
		return false
	return true


# Override add_child to see whether the child count hits 0 or not
func add_child(node: Node, default=false) -> void:
	.add_child(node, default)
	check_visibility()


# Override remove_child to see whether the child count hits 0 or not
func remove_child(node: Node) -> void:
	.remove_child(node)
	check_visibility()


func check_visibility():
	set_visible(get_child_count() > 1)


# Override the set_visible function to also emit a signal to the "Side"
func set_visible(is_visible):
	visible = is_visible
	emit_signal("state_changed", is_visible)
