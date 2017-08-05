extends "thrustproducer.gd"

# standard gravity
const G0 = 9.80665

# in newtons
export(float) var thrustVac
export(float) var thrustASL

# in seconds
export(float) var ispVac
export(float) var ispASL

var nozzleDirection

func _ready():
    # call _ready on ThrustProducer
    ._ready()
    # calculate sea level thrust from isp
    if thrustASL == 0 and ispASL != 0:
        thrustASL = ispASL / ispVac * thrustVac

func getThrustVector():
    return -nozzleDirection * getThrust()

func setNozzleDirection(new):
    nozzleDirection = new.normalized()

func getThrust():
    return lerp(thrustVac, thrustASL, global.atmosphericPressure)

func getIsp():
    return lerp(ispVac, ispASL, global.atmosphericPressure)

func getMassFlowRate():
    return getThrust() / (G0 * getIsp())
