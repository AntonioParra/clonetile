extends Node

# warning-ignore:unused_signal
signal request_navigation
signal begin

onready var map = $Map
onready var camera = $Map/Camera
onready var player = $Map/Player
onready var crossair = $Map/Crossair
onready var blocks = $Map/Navigation2D/Blocks
onready var goals = $Map/Navigation2D/Goals
onready var enemies = $Map/Navigation2D/Enemies
onready var extras = $Map/Navigation2D/Extras
onready var tilemap = $Map/Navigation2D/TileMap
onready var hearts = $CanvasLayer/UIControl/ControlHearts
onready var audio_brick = $AudioBrick

var mouse_mod_x: int
var mouse_mod_y: int

var rng = RandomNumberGenerator.new()

var brick_scene = preload("res://blocks/Brick.tscn")
var door_scene = preload("res://blocks/Door.tscn")
var blink_scene = preload("res://blocks/BlinkBlock.tscn")
var goal_scene = preload("res://characters/Goal.tscn")
var ball_scene = preload("res://characters/Ball.tscn")
var heart_pickup_scene = preload("res://characters/HeartPickup.tscn")
var key_pickup_scene = preload("res://characters/KeyPickup.tscn")
var enemy_ball_scene = preload("res://characters/EnemyBall.tscn")
var bat_scene = preload("res://characters/Bat.tscn")
var skeleton_scene = preload("res://characters/Skeleton.tscn")
var ghost_scene = preload("res://characters/Ghost.tscn")

func _process(_delta):
	update_camera_position()
	update_crossair_position()
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		var mouse_pos = map.get_local_mouse_position()
		mouse_pos.x -= tilemap.position.x
		mouse_pos.y -= tilemap.position.y
		
		var clickable = check_clickable(mouse_mod_x, mouse_mod_y)
		var brick = check_brick(mouse_mod_x, mouse_mod_y)
		
		if not clickable:
			if brick:
				brick.on_click()
			else:
				var tilemap_pos = tilemap.world_to_map(mouse_pos)
				var tile_type = tilemap.get_cell(tilemap_pos.x, tilemap_pos.y)
				if tile_type != 0:
					audio_brick.play()
					add_brick(mouse_mod_x, mouse_mod_y)

func check_clickable(x, y):
	var items = get_tree().get_nodes_in_group("Clickables")
	for item in items:
		if x == item.global_position.x and y == item.global_position.y:
			return item
	return null
	
func check_brick(x, y):
	var bricks = get_tree().get_nodes_in_group("bricks")
	for brick in bricks:
		if x == brick.position.x and y == brick.position.y:
			return brick
	return null

func add_brick(x, y):
	add_scene(x, y, brick_scene, blocks)
	
func add_door(x, y):
	add_scene(x, y, door_scene, blocks)

func add_blink_block(x, y):
	var instance = blink_scene.instance()
# warning-ignore:return_value_discarded
	connect("begin", instance, "activate")
	add_instance(x, y, instance, blocks)
	
func add_goal(x, y):
	var goal = goal_scene.instance()
	goal.connect("goal_reached", self, "_on_goal_reached")
	add_instance(x, y, goal, goals)
	
func add_skeleton(x, y):
	var instance = skeleton_scene.instance()
	instance.target = player.get_path()
# warning-ignore:return_value_discarded
	connect("begin", instance, "activate")
	add_instance(x, y, instance, enemies)
	
func add_ghost(x, y):
	var instance = ghost_scene.instance()
	instance.target = player.get_path()
# warning-ignore:return_value_discarded
	connect("begin", instance, "activate")
	add_instance(x, y, instance, enemies)
	
func add_bat(x, y):
	var instance = bat_scene.instance()
	instance.target = player.get_path()
# warning-ignore:return_value_discarded
	connect("begin", instance, "activate")
	add_instance(x, y, instance, enemies)

func add_ball(x, y):
	add_scene(x, y, ball_scene, extras)
	
func add_heart_pickup(x, y):
	add_scene(x, y, heart_pickup_scene, extras)
func add_key_pickup(x, y):
	add_scene(x, y, key_pickup_scene, extras)

func add_enemy_ball(x, y):
	rng.randomize()
	var instance = enemy_ball_scene.instance()
	instance.direction = Vector2(rng.randi_range(-100, 100), rng.randi_range(-100, 100)).normalized()
# warning-ignore:return_value_discarded
	connect("begin", instance, "activate")
	add_instance(x, y, instance, enemies)

func add_scene(x, y, scene, parent):
	var instance = scene.instance()
	add_instance(x, y, instance, parent)

func add_instance(x, y, instance, parent):
	instance.position.x = x
	instance.position.y = y
	parent.add_child(instance)
	
func update_crossair_position():
	var event_position = map.get_local_mouse_position()
	var mouse_x = floor(event_position.x)
	var mouse_y = floor(event_position.y)
	
	mouse_x = int(mouse_x - tilemap.position.x)
	mouse_y = int(mouse_y - tilemap.position.y)
	var mod_16_x = ((mouse_x % 16) + 16) % 16
	var mod_16_y = ((mouse_y % 16) + 16) % 16
	mouse_mod_x = mouse_x - mod_16_x
	mouse_mod_y = mouse_y - mod_16_y
	
	crossair.position.x = mouse_mod_x + 8
	crossair.position.y = mouse_mod_y + 8

func update_camera_position():
	camera.global_position.x = player.global_position.x + 8
	camera.global_position.y = player.global_position.y + 8

func _on_goal_reached(_goal_instance):
	print("Level._on_goal_reached: not implemented")


func _on_Player_health_changed(current_health, change):
	hearts.hearts = current_health
	if change < 0:
		camera.shake(0.5, 0.5)
	
func begin():
	emit_signal("begin")
	

func _on_BackButton_click():
	print("Level._on_BackButton_click: not implemented")


func _on_Player_key_picked():
	audio_brick.play()
	get_tree().call_group("Doors", "queue_free")
