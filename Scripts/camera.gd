extends Camera2D

var shake_amount = 0
@onready var default_pos := offset

@onready var tween = get_tree().create_tween()

func _ready():
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)

func shake(amount):
	$Timer.wait_time = 0.2
	shake_amount = amount
	set_process(true)
	$Timer.start()


func _on_timer_timeout():
	set_process(false)
	tween.interpolate_value(self, "offset", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
