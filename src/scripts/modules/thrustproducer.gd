extends Spatial

export(float, 0, 100, 0.5) var thrustLimiter = 100
var active = false
var target

func _ready():
    # recursively walk upwards to find a rigidbody to apply thrust to
    target = self
    while not target extends RigidBody:
        target = target.get_node("..")
    set_fixed_process(true)

func getThrustVector():
    print("warning: ThrustProducer %s (on part %s) does not implement getThrustVector() so will apply no thrust" % [get_name(), target.get_name()])
    return Vector3(0, 0, 0)

func _fixed_process(delta):
    if active:
        target.apply_impulse(get_translation(), getThrustVector() * thrustLimiter / 100)
