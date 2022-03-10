extends Button
class_name ModularButton


var is_mouse_inside setget set_mouse_inside


func _init():
	connect("mouse_entered", self, "set_mouse_inside", [true])
	connect("mouse_exited", self, "set_mouse_inside", [false])
	if $Area2D:
		$Area2D.connect("area_entered", self, "on_enter")
	connect("resized", self, "on_resize")


func _ready():
	on_resize()


func set_mouse_inside(is_inside: bool) -> void:
	is_mouse_inside = is_inside
	$Area2D/CollisionShape2D.disabled = not is_inside
	print(rect_size)
	print(rect_global_position)


func on_resize():
	#$Area2D.position += rect_global_position
	$Area2D/CollisionShape2D.shape.extents = rect_size / 2


func on_enter(area: Area2D):
	print(area.name)
