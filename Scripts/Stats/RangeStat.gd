extends Node
class_name RangeStat

var min: int:
	set(_val):
		pass
	get():
		return (base_min + flat_additive_modifier) * (1 + percent_additive_modifier)
var max: int:
	set(_val):
		pass
	get():
		return (base_max + flat_additive_modifier) * (1 + percent_additive_modifier)

var base_min: int
var base_max: int

var flat_additive_modifier: int = 0
var percent_additive_modifier: float = 0

var value: int:
	get():
		return randi_range(min, max)


func _init(_min: int, _max: int):
	base_min = _min
	base_max = _max


func add_modifier(mod: Modifier):
	if mod.type == Modifier.Types.FLAT_ADDITIVE:
		flat_additive_modifier += mod.value
	elif mod.type == Modifier.Types.PERCENT_ADDITIVE:
		percent_additive_modifier += mod.value


func _to_string() -> String:
	return str(min) + "-" + str(max)
