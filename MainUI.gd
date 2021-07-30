extends Control

#
# In the current state, this node is the root node of the LL.
#

var docks = []
signal ui_loaded
onready var floating_ui: Control = $FloatingUI


func _ready():
	docks.append($MarginContainer/Split/Left/Left/Top)
	docks.append($MarginContainer/Split/Left/Left/Bot)
	docks.append($MarginContainer/Split/Left/Right/Top)
	docks.append($MarginContainer/Split/Left/Right/Bot)
	docks.append($MarginContainer/Split/Right/Right/Left/Top)
	docks.append($MarginContainer/Split/Right/Right/Left/Bot)
	docks.append($MarginContainer/Split/Right/Right/Right/Top)
	docks.append($MarginContainer/Split/Right/Right/Right/Bot)
	
	_inject()
	emit_signal("ui_loaded")


func _inject():
	for dock in docks:
		dock.main_ui = self
		for child in dock.get_children():
			pass


