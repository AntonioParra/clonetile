class_name Brick extends StaticBody2D

var ready = false

export(int) var max_health = 2
var health = max_health
var invulnerable = false

onready var sprite_full = $SpriteFull
onready var sprite_damaged = $SpriteDamaged
onready var sprite_broken = $SpriteBroken
onready var collision = $CollisionPolygon2D
onready var invulnerabilityTimer = $InvulnerabilityTimer
onready var audio = $Audio

func _ready():
	ready = true
	
func take_damage(damage):
	if not invulnerable:
		invulnerable = true
		audio.play()
		invulnerabilityTimer.start()
		health -= damage
		if health < 0:
			health = 0

func _process(_delta):
	if not ready:
		return
	
	if health > max_health / 2:
		sprite_full.visible = true
		sprite_damaged.visible = false
		sprite_broken.visible = false
	elif health > 0:
		sprite_full.visible = false
		sprite_damaged.visible = true
		sprite_broken.visible = false
	elif health <= 0:
		sprite_full.visible = false
		sprite_damaged.visible = false
		sprite_broken.visible = true
		
	if health > 0:
		collision.disabled = false
	elif health <= 0:
		collision.disabled = true

#func _unhandled_input(event):
#	if mouse_hover and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
#		get_tree().set_input_as_handled()
#		audio.play()
#		if health > 0:
#			health = 0
#		else:
#			health = max_health

func on_click():
	audio.play()
	if health > 0:
		health = 0
	else:
		health = max_health


func _on_InvulnerabilityTimer_timeout():
	invulnerable = false
