extends StaticBody2D

onready var block = $AnimatedBlock
onready var space = $AnimatedSpace
onready var collision = $CollisionPolygon2D

var active = true

func _process(_delta):
	block.visible = active
	space.visible = not active
	collision.disabled = not active


func _on_AnimatedBlock_animation_finished():
	active = not active
	
func activate():
	block.playing = true
	space.playing = true
