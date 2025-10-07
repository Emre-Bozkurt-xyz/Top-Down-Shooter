extends Node
class_name FlatStat

var value: float:
	set(_val):
		pass
	get():
		return (base_value + flat_additive_modifier) * (1.0 + percent_additive_modifier)
var base_value: float

var flat_additive_modifier: int = 0
var percent_additive_modifier: float = 0

func _init(_value: float):
	base_value = value


func add_modifier(mod: Modifier):
	if mod.type == Modifier.Types.FLAT_ADDITIVE:
		flat_additive_modifier += mod.value
	elif mod.type == Modifier.Types.PERCENT_ADDITIVE:
		percent_additive_modifier += mod.value
