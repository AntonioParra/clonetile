extends KinematicBody2D

export(int) var speed = Constants.base_speed() * 2

export(Vector2) var direction = Vector2.ZERO

var active = false

func activate():
	active = true

func _physics_process(delta):
	if not active:
		return
		
		
	var collision_info = move_and_collide(direction.normalized() * speed * delta)
	if collision_info:
		direction = direction.bounce(collision_info.normal)
		
		if collision_info.collider.has_method("take_damage"):
			collision_info.collider.take_damage(1)
