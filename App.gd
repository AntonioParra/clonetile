extends Node2D

onready var level_container = $LevelContainer
onready var transition_layer = $TransitionLayer

var menu_scene = preload("res://menu/MenuLevel.tscn")

func _ready():
	set_level(menu_scene, null)
	
func set_level(scene, param):
	var children = level_container.get_children()
	for child in children:
		child.queue_free()
	
	var level_instance = scene.instance()
	level_instance.connect("request_navigation", self, "change_level")
	if level_instance.has_method("initialize"):
		level_instance.initialize(param)
	level_container.add_child(level_instance)
	
	return level_instance

func change_level(scene, param, color, text, duration):
	transition_layer.start(scene, param, color, text, duration)

