extends Button
# A variable for the future part class
var part = null
# Declare signals
signal partButtonHovered
signal partButtonClicked
# Set the part variable on init
func _init(p):
	p = part
	set_text(p.name)
func _ready():
	set_fixed_process(true)
func _fixed_process(delta):
	if is_hovered():
		emit_signal(partButtonHovered, part)
	if is_clicked():
		emit_signal(partButtonClicked, part)