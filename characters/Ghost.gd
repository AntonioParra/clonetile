extends KinematicBody2D

export(int) var speed = Constants.base_speed() / 3
export(NodePath) var target

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
		if target != null:
			var target_node = get_node(target)
			if target_node != null:
				var direction = global_position.direction_to(target_node.global_position)
				direction = move_and_slide(direction.normalized() * speed)
				
				for index in get_slide_count():
					var collision_info = get_slide_collision(index)
					if collision_info.collider.has_method("take_damage"):
						collision_info.collider.take_damage(1)
	else:
		if not particle_emitter.emitting:
			queue_free()


