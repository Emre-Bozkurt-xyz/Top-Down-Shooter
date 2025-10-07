extends Node
class_name PercentStat

var value: float:
	set(_val):
		pass
	get():
		return (base_value + flat_additive_modifier) * (1 + percent_additive_modifier)

var base_value: float

var flat_additive_modifier: int = 0
var percent_additive_modifier: float = 0


func _init(percent_value):
	base_value = percent_value


func add_modifier(mod: Modifier):
	if mod.type == Modifier.Types.FLAT_ADDITIVE:
		flat_additive_modifier += mod.value
	elif mod.type == Modifier.Types.PERCENT_ADDITIVE:
		percent_additive_modifier += mod.value


func _to_string() -> String:
	return "%" + str(floori(value*100))
