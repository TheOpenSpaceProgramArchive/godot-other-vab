extends Spatial
var name = "SpamCan"
var manufacturer = "Stom Labs"
var description = "The SpamCan by Stom Labs will suit you very well 10% of the time and for 10% of your missions"
var rocketfuel_capacity = 100
var oxidizer_capacity = 100
var option_checkbox_any = true
var option_slider_any = 100 
func _ready():
	if global.flight == true:
		pass