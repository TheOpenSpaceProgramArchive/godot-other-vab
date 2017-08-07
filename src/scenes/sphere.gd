extends Area
var target = self
func _ready():
	while not target extends RigidBody:
		target = target.get_node("..")
	get_node("PinJoint").set_node_a(target.get_path())
