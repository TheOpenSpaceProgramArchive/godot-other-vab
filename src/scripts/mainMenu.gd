extends Node
onready var button1 = get_node("spaceCenterButton")
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
func _fixed_process(delta):
	if button1.is_pressed():
		print("Hello!")
