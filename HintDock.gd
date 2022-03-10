extends Area2D


var inside := false
var current_button
var main_ui


func _ready():
	connect("area_entered", self, "on_enter")
	connect("area_exited", self, "on_exit")


func on_enter(body):
	inside = true
	current_button = body.get_parent().get_parent()
	print(current_button)
	get_parent().visible = true


func on_exit(body):
	inside = false

	if get_parent().get_child_count() <= 1:
		get_parent().visible = false


func _unhandled_input(input: InputEvent) -> void:
	if input is InputEventMouseButton:
		if input.button_index == BUTTON_LEFT:
			if (not input.pressed) and inside:
				main_ui.floating_ui.remove_child(current_button)
				current_button.is_docked = true
				get_parent().add_child(current_button)
