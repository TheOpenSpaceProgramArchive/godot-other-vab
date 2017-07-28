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
		elif dir.current_is_dir():
			print("found dir")
	dir.list_dir_end()
	return files
func loadParts():
	var partList = list_files_in_directory(partPath)
	for i in partList:
		var p = ResourceLoader.load(partPath + "/" + i +"/"+ i + ".scn")
		var pi = p.instance()
		var partButton = ResourceLoader.load("res://src/scenes/partButton.tscn")
		var pb = partButton.instance()
		pb.create(pi.name, pi.type, pi.description, pi.manufacturer, partPath + "/" + pi.name +"/"+ pi.name + ".scn")
		get_node("gui/partSelect/"+pi.type+"/"+pi.type+"/"+pi.type).add_child(pb)
		#classList.append(part.new(pi.name, pi.type, pi.description, pi.manufacturer, partPath + "/" + i +"/"+ i + ".scn"))
		pi.queue_free()
func _ready():
	loadParts()
	#for i in classList:
	#	var button = Button.new()
	#	button.set_text(i.name)
	set_fixed_process(true)
func _fixed_process(delta):
	if get_node("gui/toolbar/exitButton").is_pressed():
		global.setScene("res://src/scenes/oscMenu.tscn")