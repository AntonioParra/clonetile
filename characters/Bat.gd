extends KinematicBody2D

export(int) var speed = Constants.base_speed() / 2
export(NodePath) var target

onready var _agent: NavigationAgent2D = $NavigationOffset/NavigationAgent2D
onready var sprite = $Sprite
onready var collision_polygon = $CollisionPolygon2D
onready var particle_emitter = $Particles2D
onready var audio_damage = $AudioDamage

var alive = true
var active = false

func activate():
	active = true

func kill():
	alive = false
	sprite.visible = false
	collision_polygon.disabled = true
	
	audio_damage.play()
	particle_emitter.emitting = true


func _physics_process(_delta):
	if not active:
		return
		
		
	if alive:
		if _agent.is_navigation_finished():
			return
		
		var global_position_mod = global_position
		global_position_mod.x += 8
		global_position_mod.y += 8
		var direction = global_position_mod.direction_to(_agent.get_next_location())
		direction = move_and_slide(direction.normalized() * speed)
		
		for index in get_slide_count():
			var collision_info = get_slide_collision(index)
			if collision_info.collider.has_method("take_damage"):
				collision_info.collider.take_damage(1)
	else:
		if not particle_emitter.emitting:
			queue_free()

func _on_Navigation_Timer_timeout():
	if(target != null):
		var target_node = get_node(target)
		var target_position = target_node.global_position
		target_position.x += 8
		target_position.y += 8
		_agent.set_target_location(target_position)
