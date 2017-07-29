extends Node
var rocket = null
var partPath = "res://assets/content/parts/"
onready var plane = get_node("ViewportSprite/vabRocketBuild/gimbal/innergimbal/zoom/plane")
onready var camera = get_node("ViewportSprite/vabRocketBuild/gimbal/innergimbal/zoom/cam")
# A counter to manage reseting the partInfo area
var counter = 1
var building = false
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
func vabControl():
	if building == true:
		var ray_length = 1000
		var from = camera.project_ray_origin(get_viewport().get_mouse_pos())
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_pos()) * ray_length
		var directState = PhysicsServer.space_get_direct_state(plane.get_world().get_space())
		var result = directState.intersect_ray(from,to, Array(), 2147483647, 16)
		if result.has("position"):
			var newTransform = Transform(plane.get_child(0).get_global_transform().basis, result.position)
			plane.get_child(0).set_global_transform(newTransform)
			print(result.position)
		print(result.keys())
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
	if rocket.get_child_count() < 1:
		var p = ResourceLoader.load(pa)
		var pi = p.instance()
		rocket.add_child(pi)
		pi.set_translation(Vector3(0,0,0))
	elif building == false:
		var p = ResourceLoader.load(pa)
		var pi = p.instance()
		var transform = pi.get_global_transform()
		plane.add_child(pi)
		pi.set_global_transform(transform)
		building = true
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