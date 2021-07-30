extends TabContainer
class_name Dock

var main_ui: Control
var currently_dragging: bool = false
var is_inside_tab_bar: bool = false
signal state_changed(active)


func _ready():
	connect("tab_selected", self, "signal_tab")
	check_state()


func _input(input: InputEvent):
	if input is InputEventMouseButton:
		handle_mouse_button(input)
	if input is InputEventMouseMotion:
		handle_mouse_motion(input)


func handle_mouse_button(input: InputEventMouseButton):
	if input.button_index == BUTTON_LEFT:
		if input.pressed == false:
			currently_dragging = false
			if is_inside_tab_bar:
				if main_ui.floating_ui.get_child_count():
					for child in main_ui.floating_ui.get_children():
						if is_inside_tab_bar(child.rect_global_position) and visible:
							main_ui.floating_ui.remove_child(child)
							add_child(child)
		else: 
			if is_inside_tab_bar: 
				currently_dragging = true


func handle_mouse_motion(input: InputEventMouseMotion):
	if not is_inside_tab_bar(input.global_position):
		is_inside_tab_bar = false
		if currently_dragging:
			var modular_tab = get_tab_control(current_tab)
			if modular_tab:
				remove_child(modular_tab)
				main_ui.floating_ui.add_child(modular_tab)
				modular_tab.rect_size = modular_tab.rect_min_size
				modular_tab.currently_dragging = true
				currently_dragging = false
	else: 
		is_inside_tab_bar = true


func is_inside_tab_bar(position: Vector2) -> bool:
	var global_tab_bar_extent = rect_global_position + Vector2(rect_size.x, 23) 
	if position.x < rect_global_position.x or position.y < rect_global_position.y:
		return false
	if position.x > global_tab_bar_extent.x or position.y > global_tab_bar_extent.y:
		return false
	return true


func add_child(node: Node, default=false):
	.add_child(node, default)
	check_state()


func remove_child(node: Node):
	.remove_child(node)
	check_state()


func check_state():
	visible = get_child_count() > 0


func set_visible(is_visible):
	visible = is_visible
	emit_signal("state_changed", is_visible)
