extends Camera2D

var shake_amount = 0
var default_offset = offset
onready var tween = $ShakerTween
onready var timer = $ShakerTimer

func _ready():
	set_process(false)
	randomize()
	
func _process(_delta):
	offset = Vector2(rand_range(-1, 1) * shake_amount, rand_range(-1, 1) * shake_amount)

func shake(time, amount):
	timer.wait_time = time
	shake_amount = amount
	set_process(true)
	timer.start()

func _on_ShakerTimer_timeout():
	offset = default_offset
	set_process(false)
