extends Node
var partPath = "res://assets/content/parts/"
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
		var p = ResourceLoader.load(partPath + "/" + i +"/"+ i + ".scn")
		var pi = p.instance()
		# Create an instance of a partButton
		var partButton = ResourceLoader.load("res://src/scenes/partButton.tscn")
		var pb = partButton.instance()
		# Populate it with info about its part
		pb.create(pi.name, pi.type, pi.description, pi.manufacturer, partPath + "/" + pi.name +"/"+ pi.name + ".scn")
		# Add the button as a child of the appropriate toolbar
		get_node("gui/partSelect/"+pi.type+"/"+pi.type+"/"+pi.type).add_child(pb)
		# Connect the signals
		pb.connect("partButtonHovered", self, "onPartButtonHovered")
		pb.connect("partButtonClicked", self, "onPartButtonClicked")
		# Uninstance the part
		pi.queue_free()
func onPartButtonHovered(na, man, des):
	get_node("gui/Control/Control/partName").set_text(na)
	get_node("gui/Control/Control/partManufacturer").set_text(man)
	get_node("gui/Control/Control/partDescription").set_text(des)
func _ready():
	loadParts()
	set_fixed_process(true)
func _fixed_process(delta):
	#exit button function
	if get_node("gui/toolbar/exitButton").is_pressed():
		global.setScene("res://src/scenes/oscMenu.tscn")