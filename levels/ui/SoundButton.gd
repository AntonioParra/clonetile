extends Control

signal click

onready var node = $Node2D
onready var sprite = $Node2D/Sprite
onready var audio_click = $Node2D/AudioClick
var original

var audio_bus = AudioServer.get_bus_index("Master")
var muted

var texture_on = preload("res://assets/tiles/soundOn.png")
var texture_off = preload("res://assets/tiles/soundOff.png")

func _ready():
	original = node.modulate
	muted = AudioServer.is_bus_mute(audio_bus)
	
func _process(_delta):
	if muted:
		sprite.texture = texture_off
	else:
		sprite.texture = texture_on

func _on_Clickable_click():
	audio_click.play()
	emit_signal("click")
	
	muted = not muted
	AudioServer.set_bus_mute(audio_bus, muted)

func _on_Area2D_mouse_entered():
	node.modulate = Color(1.75, 1.75, 1.75, 1)

func _on_Area2D_mouse_exited():
	node.modulate = original
