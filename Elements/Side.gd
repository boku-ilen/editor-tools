extends Control

#
# A "side" is a splitcontainer containing two "docks" (see Dock.gd) which will
# automatically hide when it has 0 children and vice versa.
#


var docks_visible: int = 0


func _ready() -> void:
	# Loop through all children to see wheter the side is visible or not
	for child in get_children():
		if child is Dock:
			evaluate_state(child.visible)
			child.connect("state_changed", self, "evaluate_state")


# Override add_child to connect any new docks state_changed signal
func add_child(node: Node, default=false) -> void:
	.add_child(node, default)
	if node is Dock:
		node.connect("state_changed", self, "evaluate_state")


# Override remove_child to disconnect any new docks state_changed signal
func remove_child(node: Node) -> void:
	.remove_child(node)
	if node is Dock:
		node.disconnect("state_changed", self, "evaluate_state")


# Evaluate whether or not this "Side" needs to be visualized
func evaluate_state(is_visible: bool) -> void:
	if is_visible: docks_visible +=1
	else: docks_visible -=1
	
	visible = docks_visible > 0
