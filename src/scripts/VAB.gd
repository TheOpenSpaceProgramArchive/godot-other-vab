extends Node
var partPath = "rev//assets/content/parts"
class part:
	var name
	var type
	var description
	var manufacturer
	func _init(na, ty, des, man):
		name = na
		type = ty
		description = des
		manufacturer = man
func _ready():
	set_fixed_process(true)
func _fixed_process(delta):
	if get_node("gui/toolbar/exitButton").is_pressed():
		global.setScene("res://src/scenes/oscMenu.tscn")