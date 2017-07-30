extends RigidBody
var name = "Coolie"
var manufacturer = "Stom Labs"
var type = "engines"
var description = "The Coolie. An engine with 100% of the thrust and only a 70% failure rate!"
var rocketfuel_capacity = 100
var oxidizer_capacity = 100
var option_checkbox_any = true
var option_slider_any = 100 
func _ready():
	if global.flight == true:
		pass