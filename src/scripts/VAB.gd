extends Node
var partPath = "res://assets/content/parts/"
var classList = []
class part:
	var name
	var type
	var description
	var manufacturer
	var path
	func _init(na, ty, des, man, pa):
		name = na
		type = ty
		description = des
		manufacturer = man
		path = pa
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
		classList.append(part.new(pi.name, pi.type, pi.description, pi.manufacturer, partPath + "/" + i +"/"+ i + ".scn"))
		pi.queue_free()
func _ready():
	loadParts()
	for i in classList:
		var button = Button.new()
		button.set_text(i.name)
		get_node("gui/partSelect/"+i.type+"/"+i.type+"/"+i.type).add_child(button)
	set_fixed_process(true)
func _fixed_process(delta):
	if get_node("gui/toolbar/exitButton").is_pressed():
		global.setScene("res://src/scenes/oscMenu.tscn")