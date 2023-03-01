extends CanvasLayer

export(NodePath) var manager 

export(int) var text_scale = 4
var animation_name = "fade"
var active = false

onready var text_node = $Text
onready var sprites_container = $Text/SpritesContainer
onready var animation_player = $AnimationPlayer

func start(scene, param, color, text, duration):
	active = true
	# prepare
	prepare(color, text)
	
	
	# fade in
	animation_player.play(animation_name)
	yield(animation_player, "animation_finished")
	
	# chance scene
	var instance = get_node(manager).set_level(scene, param)
	yield(get_tree().create_timer(duration - animation_player.get_animation(animation_name).length * 2), "timeout")

	# fade out
	animation_player.play_backwards(animation_name)
	yield(animation_player, "animation_finished")
	active = false
	if instance.has_method("begin"):
		instance.begin()
	
func prepare(_color, text):
	for child in sprites_container.get_children():
		child.queue_free()
	sprites_container.scale = Vector2(text_scale, text_scale)
	
	var length = len(text)
	for index in length:
		var ch = text[index]
		var sprite = Sprite.new()
		sprite.position.x = (index - length / 2) * 16 + (8 if length % 2 == 0 else 0)
		if _is_letter(ch):
			sprite.texture = load("res://assets/tiles/letter" + ch.to_upper() + ".png")
		elif _is_number(ch):
			sprite.texture = load("res://assets/tiles/number" + str(ch) + ".png")
		sprites_container.add_child(sprite)
		
func _is_number(ch):
	var regex = RegEx.new()
	regex.compile("[0-9]")
	return regex.search(ch)

func _is_letter(ch):
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]")
	return regex.search(ch)
	
func _process(_delta):
	text_node.position = get_viewport().size / 2
	#sprites_container.modulate.a = text_node.modulate.a
	#for child in sprites_container.get_children():
	#	child.modulate.a = text_node.modulate.a
	
func _unhandled_input(_event):
	if active:
		get_tree().set_input_as_handled()
