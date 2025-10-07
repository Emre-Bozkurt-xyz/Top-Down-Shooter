class_name NumberRange extends Node

var min_num
var max_num

var rand: RandomNumberGenerator = RandomNumberGenerator.new()

func _init(min: float, max: float) -> void:
	min_num = min
	max_num = max

func get_num() -> float:
	return rand.randf_range(min_num, max_num)
