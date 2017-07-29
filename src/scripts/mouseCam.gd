extends Camera

var pressed = false
var last_position = Vector2()


func _ready():
    set_process_unhandled_input(true)


func _unhandled_input(event):
    if event.type == InputEvent.MOUSE_BUTTON:
        pressed = event.is_pressed()
        if pressed:
            last_position = event.pos
    elif event.type == InputEvent.MOUSE_MOTION and pressed:
        var delta = event.pos - last_position
        last_position = event.pos
        get_node(".").rotate_y(-delta.x * 0.01)
        get_node("innergimbal").rotate_y(-delta.x * 0.01)
		