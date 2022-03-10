extends Control

#
# In the current state, this node is the root node of the LL.
#

var docks = []
signal ui_loaded
onready var floating_ui: Control = $FloatingUI


func _ready():
	$MarginContainer.connect("mouse_exited", self, "hint_docking")
	docks.append($MarginContainer/Split/Left/Left/Top)
	docks.append($MarginContainer/Split/Left/Left/Bot)
	docks.append($MarginContainer/Split/Left/Right/Top)
	docks.append($MarginContainer/Split/Left/Right/Bot)
	docks.append($MarginContainer/Split/Right/Right/Left/Top)
	docks.append($MarginContainer/Split/Right/Right/Left/Bot)
	docks.append($MarginContainer/Split/Right/Right/Right/Top)
	docks.append($MarginContainer/Split/Right/Right/Right/Bot)
	docks.append($MarginContainer/Split/Left/Left/Top/HoverArea)
	docks.append($MarginContainer/Split/Left/Left/Bot/HoverArea)
	
	emit_signal("ui_loaded")
	_inject()


func _inject():
	for dock in docks:
		dock.main_ui = self
		for child in dock.get_children():
			pass


func hint_docking():
	print("exited")
	print(get_viewport().get_mouse_position().x)
	print($MarginContainer.rect_global_position.x)
	print("\n\n")
	
	if floating_ui.active_tab:
		if get_viewport().get_mouse_position().x < $MarginContainer.rect_global_position.x:
			print("left")
		elif get_viewport().get_mouse_position().x > $MarginContainer.rect_global_position.x + $MarginContainer.rect_size.x:
			print("right")
