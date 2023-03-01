extends Node2D

signal click

export(int) var level

onready var number_sprite = $Number
onready var audio_click = $AudioClick

var mouse_hover = false
var original = modulate

func _ready():
	number_sprite.texture = load("res://assets/tiles/number" + str(level) + ".png")
	
func _unhandled_input(event):
	if mouse_hover and event is InputEventMouseButton and event.is_pressed():
		get_tree().set_input_as_handled()
		if event.button_index == BUTTON_LEFT:
			audio_click.play()
			emit_signal("click")

func _on_mouse_entered():
	mouse_hover = true
	modulate = Color(1.75, 1.75, 1.75, 1)

func _on_mouse_exited():
	mouse_hover = false
	modulate = original
