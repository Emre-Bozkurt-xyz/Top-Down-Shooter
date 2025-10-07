extends Node
class_name Modifier

enum Types {
	PERCENT_ADDITIVE,
	FLAT_ADDITIVE
}

var value
var type: Types

func _init( _value, _type: Types):
	value = _value
	type = _type
