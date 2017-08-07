extends Node
var rocket = null
var connectArray = Array()
var buildingConnectArray = Array()
var partPath = "res://assets/content/parts/"
var currentBuild = null
onready var plane = get_node("ViewportSprite/vabRocketBuild/gimbal/innergimbal/zoom/plane")
onready var camera = get_node("ViewportSprite/vabRocketBuild/gimbal/innergimbal/zoom/cam")
# A counter to manage reseting the partInfo area
var counter = 1
#Helper variables
var building = false
var attached = false
var mouseEntered = false
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
            files.append(file)
	dir.list_dir_end()
	return files
func loadParts():
	var partList = list_files_in_directory(partPath)
	for i in partList:
		# Create an instance of a part
		var partpart = partPath + "/" + i +"/"+ i + ".scn" 
		var p = ResourceLoader.load(partPath + "/" + i +"/"+ i + ".scn")
		var pi = p.instance()
		# Create an instance of a partButton
		var partButton = ResourceLoader.load("res://src/scenes/partButton.tscn")
		var pb = partButton.instance()
		# Populate it with info about its part
		pb.create(pi.name, pi.type, pi.description, pi.manufacturer, partpart)
		# Add the button as a child of the appropriate toolbar
		get_node("gui/partSelect/"+pi.type+"/"+pi.type+"/"+pi.type).add_child(pb)
		# Connect the signals
		pb.connect("partButtonHovered", self, "onPartButtonHovered")
		pb.connect("partButtonClicked", self, "onPartButtonClicked")
		# Uninstance the part
		pi.queue_free()
func attachParts():
	pass
func vabControl():
	if building:
		for i1 in buildingConnectArray:
			if (!i1.get_ref()):
				pass
			else:
				i1 = i1.get_ref()
				for i2 in i1. get_overlapping_areas ( ):
					if i2.get_name().find("connect") != -1:
							attached = true
							i1.set_global_transform(i2.get_global_transform())
					else:
							attached = false
	if Input.is_mouse_button_pressed(1):
		if building == true:
			building = false
		elif building == false and mouseEntered:
			building = true
	if building == true:
		var ray_length = 1000
		var from = camera.project_ray_origin(get_viewport().get_mouse_pos())
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_pos()) * ray_length
		var directState = PhysicsServer.space_get_direct_state(plane.get_world().get_space())
		var result = directState.intersect_ray(from,to, Array(), 2147483647, 16)
		if result.has("position"):
			var newTransform = Transform(plane.get_child(0).get_global_transform().basis, result.position)
			plane.get_child(0).set_global_transform(newTransform)
		if plane.get_child_count() > 1:
			plane.get_child(0).queue_free()
func onPartButtonHovered(na, man, des):
	counter = 1
	get_node("gui/parts/partInfo/partName").set_text(na)
	get_node("gui/parts/partInfo/partManufacturer").set_text(man)
	get_node("gui/parts/partInfo/partDescription").set_text(des)
func onPartButtonClicked(na, man, des, pa):
	counter = 1
	get_node("gui/parts/partInfo/partName").set_text(na)
	get_node("gui/parts/partInfo/partManufacturer").set_text(man)
	get_node("gui/parts/partInfo/partDescription").set_text(des)
	rocket.set_mass(0)
	if building == false and rocket.get_child_count() >= 1:
		var p = ResourceLoader.load(pa)
		var pi = p.instance()
		pi.set_mode(3)
		pi.connect("mouse_enter", self, "partMouseEnter")
		pi.connect("mouse_exit", self, "partMouseExit")
		var transform = pi.get_global_transform().translated(Vector3(100,100,100))
		plane.add_child(pi)
		pi.set_global_transform(transform)
		for i in pi.get_children():
			if i.get_name().find("connect") != -1:
				buildingConnectArray.append(weakref(i))
		building = true
	elif rocket.get_child_count() < 1:
		var p = ResourceLoader.load(pa)
		var pi = p.instance()
		pi.set_mode(3)
		rocket.add_child(pi)
		pi.set_translation(Vector3(0,0,0))
func partMouseEnter():
	mouseEntered = true
func partMouseExit():
	mouseEntered = false
func _ready():
	if rocket == null:
		rocket = get_node("ViewportSprite/vabRocketBuild/rocket")
	loadParts()
	set_fixed_process(true)
func _fixed_process(delta):
	vabControl()
	#If there is no signal from a button then clear the Partinfo area
	counter += 1
	if counter > 5:
		get_node("gui/parts/partInfo/partName").set_text("")
		get_node("gui/parts/partInfo/partManufacturer").set_text("")
		get_node("gui/parts/partInfo/partDescription").set_text("")
	#exit button function
	if get_node("gui/toolbar/exitButton").is_pressed():
		global.setScene("res://src/scenes/oscMenu.tscn")

