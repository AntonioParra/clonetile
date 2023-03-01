extends Control

export(int) var hearts = 3

var heart_full = preload("res://assets/tiles/heartFull.png")
var heart_empty = preload("res://assets/tiles/heartEmpty.png")
onready var heart1 = $Hearts2D/Heart1
onready var heart2 = $Hearts2D/Heart2
onready var heart3 = $Hearts2D/Heart3

func _process(_delta):
	if hearts >= 3:
		heart1.texture = heart_full
		heart2.texture = heart_full
		heart3.texture = heart_full
	elif hearts == 2:
		heart1.texture = heart_full
		heart2.texture = heart_full
		heart3.texture = heart_empty
	elif hearts == 1:
		heart1.texture = heart_full
		heart2.texture = heart_empty
		heart3.texture = heart_empty
	elif hearts <= 0:
		heart1.texture = heart_empty
		heart2.texture = heart_empty
		heart3.texture = heart_empty
		
