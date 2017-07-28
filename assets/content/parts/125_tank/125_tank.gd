extends Spatial
var name = "Juggernaut V1"
var manufacturer = "Stom Labs"
var type = "tanks"
var description = "The Juggernaut V1 will hold most of the fuel you will need for your missions"
var rocketfuel_capacity = 10000
var oxidizer_capacity = 10000
var option_checkbox_any = true
var option_slider_any = 100 
func _ready():
	if global.flight == true:
		pass