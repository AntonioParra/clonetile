class_name Ball extends KinematicBody2D

export(int) var speed = Constants.base_speed() * 2

export(Vector2) var direction = Vector2.ZERO

onready var particles2D = $Particles2D

func _physics_process(delta):
	direction = direction.normalized()
	particles2D.process_material.direction = Vector3(-direction.x, -direction.y, 0)
	var collision_info = move_and_collide(direction * speed * delta)
	if collision_info:
		direction = direction.bounce(collision_info.normal)
		
		if collision_info.collider.has_method("kill"):
			collision_info.collider.kill()
			
		if collision_info.collider.has_method("on_collision"):
			collision_info.collider.on_collision(self)
		
func start_move(direction2):
	if(self.direction == Vector2.ZERO):
		particles2D.emitting = true
		self.direction = direction2.normalized()
