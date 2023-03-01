extends "res://levels/Level.gd"

var level_scene = preload("res://levels/LevelFromTemplate.tscn")

#func _unhandled_input(event):
#	if event is InputEventKey and event.is_pressed() and event.scancode == KEY_SPACE:
#		enter_level_aux()
		
func enter_level(level_number):
	var level_path = "res://levels/templates/level" + str(level_number) + ".txt"
	emit_signal("request_navigation", level_scene, level_path, Constants.color_neutral(), "Level " + str(level_number), 2)
		
func enter_level_aux():
	var os_path = OS.get_executable_path()
	var parts = os_path.split("/")
	parts[len(parts) - 1] = "level.txt"
	var level_path = parts.join("/")
	
	emit_signal("request_navigation", level_scene, level_path)


func _on_ButtonLevel1_click():
	enter_level(1)
func _on_ButtonLevel2_click():
	enter_level(2)
func _on_ButtonLevel3_click():
	enter_level(3)
func _on_ButtonLevel4_click():
	enter_level(4)
func _on_ButtonLevel5_click():
	enter_level(5)



