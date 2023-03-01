extends KinematicBody2D

export(int) var speed = Constants.base_speed() / 3
export(NodePath) var target

onready var sprite_alive = $SpriteAlive
onready var sprite_dead = $SpriteDead
onready var timer_dead = $TimerDead
onready var particle_emitter = $Particles2D
onready var audio_damage = $AudioDamage

var alive = true
var active = false

func activate():
	active = true

onready var _agent: NavigationAgent2D = $NavigationOffset/NavigationAgent2D

func kill():
	if alive:
		alive = false
		
		audio_damage.play()
		particle_emitter.emitting = true
		timer_dead.stop()
		timer_dead.start()
	
func reanimate():
	alive = true

func _physics_process(_delta):
	if not active:
		return
		
		
	sprite_alive.visible = alive
	sprite_dead.visible = !alive
	
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

func _on_Navigation_Timer_timeout():
	if target != null:
		var target_node = get_node(target)
		if target_node != null:
			var target_position = target_node.global_position
			target_position.x += 8
			target_position.y += 8
			_agent.set_target_location(target_position)



func _on_TimerDead_timeout():
	reanimate()
