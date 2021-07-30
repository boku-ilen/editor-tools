extends Control


var docks_visible: int = 0


func _ready():
	for child in get_children():
		if child is Dock:
			evaluate_state(child.visible)


func add_child(node: Node, default=false):
	.add_child(node, default)
	if node is Dock:
		node.connect("state_changed", self, "evaluate_state")


func remove_child(node: Node):
	.remove_child(node)
	if node is Dock:
		node.disconnect("state_changed", self, "evaluate_state")


func evaluate_state(is_visible: bool):
	if is_visible: docks_visible +=1
	else: docks_visible -=1
	
	visible = docks_visible > 0
