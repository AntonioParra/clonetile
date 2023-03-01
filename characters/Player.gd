extends KinematicBody2D

signal health_changed
signal key_picked

onready var invulnerabilityTimer = $InvulnerabilityTimer
onready var particles2D = $Particles2D
onready var sprite = $Sprite
onready var damage_audio = $DamageAudio

export(int) var speed = Constants.base_speed()
export(int) var max_health = 3
var health = max_health
var invulnerable = false

var moving_left = false
var moving_right = false
var moving_up = false
var moving_down = false

func take_damage(damage):
	if not invulnerable:
		invulnerable = true
		damage_audio.play()
		invulnerabilityTimer.start()
		health -= damage
		if health < 0:
			health = 0
			
		if health == 0:
			sprite.visible = false
			particles2D.emitting = true

		emit_signal("health_changed", health, -damage)

func heal(healing):
	health = health + healing
	if health > max_health:
		health = max_health
		
	emit_signal("health_changed", health, healing)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("move_down"):
		moving_down = true
	if Input.is_action_just_pressed("move_up"):
		moving_up = true
	if Input.is_action_just_pressed("move_left"):
		moving_left = true
	if Input.is_action_just_pressed("move_right"):
		moving_right = true
		
	if Input.is_action_just_released("move_down"):
		moving_down = false
	if Input.is_action_just_released("move_up"):
		moving_up = false
	if Input.is_action_just_released("move_left"):
		moving_left = false
	if Input.is_action_just_released("move_right"):
		moving_right = false
	

		
func _physics_process(_delta):
	if health <= 0:
		return
		
	var direction: Vector2 = Vector2.ZERO
	if(moving_down):
		direction.y += 1
	if(moving_up):
		direction.y -= 1
	if(moving_right):
		direction.x += 1
	if(moving_left):
		direction.x -= 1
		
	direction = move_and_slide(direction.normalized() * speed)
	
	for i in get_slide_count():
		var collision_info = get_slide_collision(i)
		if(collision_info and collision_info.collider is Ball):
			collision_info.collider.start_move(collision_info.collider.position - self.position)

func _on_InvulnerabilityTimer_timeout():
	invulnerable = false

func _on_AreaPickups_area_entered(area):
	if "pickup_type" in area.owner:
		match area.owner.pickup_type:
			"heart":
				if health < max_health:
					heal(1)
					area.owner.queue_free()
			"key":
				emit_signal("key_picked")
				area.owner.queue_free()
