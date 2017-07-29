#extends Spatial
onready var cam = get_node("innergimbal/zoom/cam")
var movePressed = false
var rotPressed = false
var last_position = Vector2()
var to
var from
onready var plane = get_node("innergimbal/zoom/plane")
func _ready():
    print(get_viewport().get_visible_rect())
    plane.set_global_transform(Transform(Vector3(get_viewport().get_visible_rect().size.width,0,0),Vector3(0,get_viewport().get_visible_rect().size.height,0),Vector3(0,0,1),Vector3(0,0,0)))
    set_process_unhandled_input(true)
    set_fixed_process(true)
    print(get_viewport().get_visible_rect())
func _unhandled_input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
         if event.button_index == BUTTON_WHEEL_UP and not Input.is_action_pressed("ui_shift"):
          cam.set_translation(cam.get_translation() + Vector3(0,0,-1))
         elif event.button_index == BUTTON_WHEEL_DOWN and not Input.is_action_pressed("ui_shift"):
          cam.set_translation(cam.get_translation() + Vector3(0,0,1))
         elif event.button_index == BUTTON_RIGHT and not Input.is_action_pressed("ui_shift"):
          rotPressed = event.is_pressed()
         elif event.button_index == BUTTON_WHEEL_UP and Input.is_action_pressed("ui_shift"):
          plane.set_translation(plane.get_translation() + Vector3(0,0,-1))
         elif event.button_index == BUTTON_WHEEL_DOWN and Input.is_action_pressed("ui_shift"):
          plane.set_translation(plane.get_translation() + Vector3(0,0,1))
         if rotPressed: 
            last_position = event.pos
         elif event.button_index == BUTTON_RIGHT and Input.is_action_pressed("ui_shift"):
          pass
	elif event.type == InputEvent.MOUSE_MOTION and rotPressed:
        var delta = event.pos - last_position
        last_position = event.pos
        self.rotate_y(delta.x * 0.01)
        get_node("innergimbal").rotate_x(delta.y * 0.01)
	if event.type == InputEvent.MOUSE_MOTION:
		pass