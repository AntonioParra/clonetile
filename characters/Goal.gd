class_name Goal extends KinematicBody2D

signal goal_reached

onready var sprite = $Sprite
onready var particles2D = $Particles2D
onready var audio_reached = $AudioReached

var original
var target

export(bool) var reached = false

func _ready():
	original = sprite.modulate
	target = original * 2
	target.a = 1

func on_collision(collider):
	if collider is Ball:
		if not reached:
			reached = true
			audio_reached.play()
			particles2D.emitting = true
			sprite.modulate = target
			emit_signal("goal_reached", self)
