extends Button


var is_mouse_inside setget set_mouse_inside


func _init():
	connect("mouse_entered", self, "set_mouse_inside", [true])
	connect("mouse_exited", self, "set_mouse_inside", [false])


func set_mouse_inside(is_inside: bool) -> void:
	is_mouse_inside = is_inside
