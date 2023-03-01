extends "res://levels/Level.gd"

var clickable_scene = preload("res://extras/Clickable.tscn")

var menu_level = load("res://menu/MenuLevel.tscn")

var template_path
 
func initialize(path):
	template_path = path
	return self
	
func _ready():
	load_level(template_path)

func load_level(path):
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	
	var height = 0
	var width = 0
	
	var lines = content.split("\n")
	var mode = {"mode": ""} 
	var extras = {}
	var line_offset = 0
	for line_number in len(lines):
		var line = lines[line_number]
		if line.find("#") == 0:
			line_offset += 1
			continue
		var next_mode = check_mode_change(mode, line)
		if(mode.mode != next_mode.mode):
			mode = next_mode
			if "inmediate" in mode and mode["inmediate"]:
				line_offset = line_number
			else:
				line_offset = line_number + 1
				continue
		match mode.mode:
			"extra":
				extras = load_level_extra_level(line, extras)
			"grid":
				var line_width = load_level_grid_line(line, line_number - line_offset, mode, extras)
				height = line_number - line_offset + 1
				width = max(width, line_width)
			"end":
				fill_tilemap(width, height)
				return
			_:
				pass
		

func check_mode_change(current_mode, line):
	if line.find("extra") == 0:
		return {"mode": "extra"}
	if line.find("grid") == 0:
		return {"mode": "grid", "step": int(line.split(" ")[1])}
	if line.find("end") == 0:
		return {"mode": "end", "inmediate": true}
	return current_mode

func load_level_extra_level(line, extras):
	var parts = line.split(" ")
	extras[parts[0]] = load(parts[1])
	return extras

func load_level_grid_line(line, line_number, mode, extras):
	var index = 0
	var world_index = 0
	for character in line:
		if index % mode.step == 0:
			match character:
				"\t":
					index += 1
					world_index += 4 / mode.step - 1
				"W":
					tilemap.set_cell(world_index, line_number, 0)
				"w":
					add_brick(world_index * 16, line_number * 16)
				"P":
					player.position.x = world_index * 16
					player.position.y = line_number * 16
				"B":
					add_ball(world_index * 16, line_number * 16)
				"D":
					add_door(world_index * 16, line_number * 16)
				"T":
					add_blink_block(world_index * 16, line_number * 16)
				"G":
					add_goal(world_index * 16, line_number * 16)
				"H":
					add_heart_pickup(world_index * 16, line_number * 16)
				"K":
					add_key_pickup(world_index * 16, line_number * 16)
				"b":
					add_bat(world_index * 16, line_number * 16)
				"e":
					add_enemy_ball(world_index * 16, line_number * 16)
				"g":
					add_ghost(world_index * 16, line_number * 16)
				"s":
					add_skeleton(world_index * 16, line_number * 16)
				_:
					if character in extras:
						var extra = extras[character] 
						var instance = extra.instance()
						var clickable_intance = clickable_scene.instance()
						instance.add_child(clickable_intance)
						add_instance(world_index * 16, line_number * 16, instance, self.extras)
						
			world_index += 1
		index += 1
	return world_index

func fill_tilemap(width, height):
	for i in width:
		for j in height:
			if tilemap.get_cell(i, j) == -1:
				tilemap.set_cell(i, j, 1)
				
func _on_goal_reached(_goal_instance):
	var all_reached = true
	for child in goals.get_children():
		all_reached = all_reached && child.reached
	if all_reached:
		yield(get_tree().create_timer(0.5), "timeout")
		emit_signal("request_navigation", menu_level, null, Constants.color_positive(), "Victory", 2.5)
		
func _on_Player_health_changed(current_health, change):
	._on_Player_health_changed(current_health, change)
	if current_health == 0:
		yield(get_tree().create_timer(0.5), "timeout")
		emit_signal("request_navigation", menu_level, null, Constants.color_negative(), "Defeat", 2.5)
		
func _on_BackButton_click():
	emit_signal("request_navigation", menu_level, null, Constants.color_negative(), "Surrender", 2.5)
				
