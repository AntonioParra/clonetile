extends Node2D

var mouse_hover = false

signal click

func _on_Area2D_mouse_entered():
	mouse_hover = true


func _on_Area2D_mouse_exited():
	mouse_hover = false
	
func _unhandled_input(event):
	if mouse_hover and event is InputEventMouseButton and event.is_pressed():
		get_tree().set_input_as_handled()
		emit_signal("click")
