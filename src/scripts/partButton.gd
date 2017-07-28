extends Button
# A variable for the future part class
var part = null
# Declare signals
signal partButtonHovered
signal partButtonClicked
# Set the part variable on init
#Create a part class
class Part:
	var name
	var type
	var description
	var manufacturer
	var path
	func _init(na, ty, des, man, pa):
		name = na
		type = ty
		description = des
		manufacturer = man
		path = pa
func create(na, ty, des, man, pa):
	part = Part.new(na, ty, des, man, pa)
	set_text(part.name)
func _ready():
	set_fixed_process(true)
func _fixed_process(delta):
	if is_hovered():
		emit_signal("partButtonHovered", part.name, part.manufacturer, part.description)
	if is_pressed():
		emit_signal("partButtonClicked", part.name, part.manufacturer, part.description, part.path)