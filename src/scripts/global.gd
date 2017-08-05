extends Node
onready var currentScene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() -1)
var usedRocket
var flight = false
onready var classes = Classes.new()
var atmosphericPressure = 0

func setScene(scene):
   #clean up the current scene
   currentScene.queue_free()
   #load the file passed in as the param "scene"
   var s = ResourceLoader.load(scene)
   #create an instance of our scene
   currentScene = s.instance()
   # add scene to root
   get_tree().get_root().add_child(currentScene)

class Classes:
    extends Reference
    
    const Part = preload("res://src/scripts/part.gd")
