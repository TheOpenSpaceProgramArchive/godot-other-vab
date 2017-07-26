extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
func _fixed_process(delta):
	if is_pressed():
	 global.setScene("res://src/scenes/launchpad.tscn")
