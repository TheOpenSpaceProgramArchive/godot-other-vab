# rotation around the y axis
export(int, 0, 360) var rotation = 0 setget set_rotation

# angle of camera w.r.t. y axis
export(int, 0, 90) var angle = 45 setget set_angle

# fovy_trombone is field of view, but attempts to keep the distance the same-ish
export(int, 0, 90) var fovy_trombone = 10 setget set_fovy_trombone

# distance from target
export(int, 0, 500) var distance = 20 setget set_distance

# A Vector3 specifying where the camera is pointed
export(Vector3) var target = Vector3(0, 0, 0) setget set_target

# Enable or disable keyboard control
const KEYBOARD_OFF    = 0
const KEYBOARD_SINGLE = 1
const KEYBOARD_SMOOTH = 2
export(int, 'off', 'single', 'smooth') var keyboard_control = 2 setget set_keyboard_control

# Emitted when the camera moves anywhere
signal moved


#############

const MARGIN = 10
const SPEED = 3 # control speed

# Used for "smooth" keyboard mode
var momentum = {
    rotation=0,
    angle=0,
    dir=Vector3(0, 0, 0),
    distance=0,
    fovy_trombone=0,
}

var tracking_target = null
var _original_zfar = null

func _init():
    _original_zfar = get_zfar()

func _ready():
    _refresh_control()
    _refresh_direction()

###### Getters / setters
func set_rotation(new_value):
    rotation = new_value
    _refresh_direction()

func set_target(new_value):
    target = new_value
    _refresh_direction()

func set_fovy_trombone(new_value):
    fovy_trombone = new_value
    _refresh_direction()

func set_angle(new_value):
    angle = new_value
    _refresh_direction()

func set_distance(new_value):
    distance = new_value
    _refresh_direction()

func set_keyboard_control(new_value):
    keyboard_control = new_value
    _refresh_control()
######

###### Tracking interface
func start_tracking(target_node):
    tracking_target = target_node
    _refresh_processing()

func stop_target(target_node):
    tracking_target = null
    _refresh_processing()
######

#
# Refreshes control settings
func _refresh_control():
    set_process_input(keyboard_control != KEYBOARD_OFF)
    _refresh_processing()

#
# Refreshes set_process settings
func _refresh_processing():
    set_process(keyboard_control == KEYBOARD_SMOOTH or tracking_target != null)

#
# Process function: If following something, move camera to look at it,
# also apply current movement (for "smooth" keyboard controls)
func _process(delta):
    if keyboard_control == KEYBOARD_SMOOTH:
        _apply_momentum(momentum, delta)
        _refresh_direction()

    if tracking_target != null:
        target = tracking_target.get_translation()
        set_target(target) # Look at the target

#
# Checks input, either single-press logic (each keyup moves a fixed
# amount upon release), or a smooth gliding style
func _input(ev):
    if keyboard_control == KEYBOARD_SINGLE:
        _input_single_press_controls(ev)
    else:
        _input_smooth_controls(ev)

#
# Main logic: refreshes direction and position of camera
func _refresh_direction():
    # Don't update if not yet _ready
    if not is_inside_tree():
        return

    # Set the fov perspective
    var fovy = deg2rad(fovy_trombone)

    # calculate the distance
    # NOTE: Not perfect calculation, but passable:
    var effective_distance = distance * 1/tan(fovy)
    #effective_distance = max(effective_distance, 4.0) # not too close
    var offset_side = Vector2(effective_distance, 0).rotated(deg2rad(angle))
    var offset = Vector3(0, -offset_side.y, offset_side.x) # from front 

    # Now rotate horizontally based on rotation
    offset = offset.rotated(Vector3(0, 1, 0), deg2rad(rotation))
    set_translation(target + offset)

    # Set perspective based on fovy specified, and znear / zfar
    var effective_zfar = max(_original_zfar, effective_distance + MARGIN)
    set_perspective(fovy_trombone, get_znear(), effective_zfar)

    # Finally look at the target point
    look_at(target, Vector3(0, 1, 0))

    # And emit the "moved" signal
    emit_signal('moved')


#
# Given a keyboard scancode, this modifies a "momentum" dictionary
# based on speed and the hard-coded control scheme
func _apply_input_scancode_to_moment(scancode, moment, speed):
    if scancode == KEY_Q:
        moment.rotation = speed * 5
    elif scancode == KEY_E:
        moment.rotation = -(speed * 5)

    if scancode == KEY_R:
        moment.angle = speed * 5
    elif scancode == KEY_F:
        moment.angle = -(speed * 5)

    if scancode == KEY_W:
        moment.dir.z = -speed
    elif scancode == KEY_S:
        moment.dir.z = speed
    if scancode == KEY_A:
        moment.dir.x = -speed
    elif scancode == KEY_D:
        moment.dir.x = speed

    if (scancode == KEY_PLUS or scancode == KEY_EQUAL):
        moment.distance = -speed
    elif scancode == KEY_MINUS:
        moment.distance = speed

    if scancode == KEY_BRACKETLEFT:
        moment.fovy_trombone = -speed
    elif scancode == KEY_BRACKETRIGHT:
        moment.fovy_trombone = speed

#
# Based on an input event, modify the momentum dict to cause motion
func _input_smooth_controls(ev):
    if ev.type != InputEvent.KEY:
        return

    var speed = SPEED * 5
    if not ev.pressed:
        speed = 0 # if 'keyup' events, reset speed

    _apply_input_scancode_to_moment(ev.scancode, momentum, speed)

#
# Based on an input event, cause motion once ("lurch" in a direction)
func _input_single_press_controls(ev):
    if ev.type != InputEvent.KEY:
        return

    if ev.pressed:
        return # only care about 'keyup' events 

    var moment = {
        rotation=0,
        angle=0,
        dir=Vector3(0, 0, 0),
        distance=0,
        fovy_trombone=0,
    }
    _apply_input_scancode_to_moment(ev.scancode, moment, SPEED)
    _apply_momentum(moment, 1.0)
    _refresh_direction()
    return

#
# Apply the given momentum dict to properties of the camera, also
# applying a delta coefficient
func _apply_momentum(moment, delta):
    rotation = _float_mod(rotation + moment.rotation * delta, 360)
    angle = clamp(angle + moment.angle * delta, 0, 90)
    distance = clamp(distance + moment.distance * delta, 0, 500)
    fovy_trombone = clamp(fovy_trombone + moment.fovy_trombone * delta, 0, 90)

    var dir = moment.dir * delta
    if dir != Vector3(0, 0, 0):
        # If not still, then rotate based on rotation and move
        dir = dir.rotated(Vector3(0, 1, 0), deg2rad(rotation))
        target += dir

#
# Utility function: Like modulus, but for floats, from 0 to max_val
func _float_mod(f, max_val):
    while f < 0:
        f += max_val
    while f >= max_val:
        f -= max_val
    return f
