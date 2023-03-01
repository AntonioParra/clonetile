extends Control

signal click

onready var node = $Node2D
onready var audio_click = $Node2D/AudioClick
var original

func _ready():
	original = node.modulate

func _on_Clickable_click():
	audio_click.play()
	emit_signal("click")

func _on_Area2D_mouse_entered():
	node.modulate = Color(1.75, 1.75, 1.75, 1)

func _on_Area2D_mouse_exited():
	node.modulate = original
