extends Node2D

var active_area = 0

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		if active_area != 0:
			get_tree().set_input_as_handled()
		match active_area:
			1:
				OS.shell_open("https://artindi.itch.io/volatile")
			2:
				OS.shell_open("https://www.kenney.nl/assets/bit-pack")
			3:
				OS.shell_open("https://chrislsound.itch.io/ambient-puzzle")

func _on_Area2D_mouse_exited():
	active_area = 0

func _on_design_mouse_entered():
	active_area = 1

func _on_graphics_mouse_entered():
	active_area = 2

func _on_sounds_mouse_entered():
	print(1)
	active_area = 3
