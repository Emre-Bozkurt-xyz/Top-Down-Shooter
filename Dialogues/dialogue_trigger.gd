extends Node2D

enum Types {
	OnParentDeath
}

@export var trigger_type: Types
@export var dialogue_resource: Resource
@export var dialogue_title: String

func _ready() -> void:
	match trigger_type:
		Types.OnParentDeath:
			var parent = get_parent()
			
			if parent:
				var death_signal = parent.died
				if death_signal:
					death_signal.connect(start_dialogue)

func start_dialogue():
	Global.current_level_manager.beginDialogue(dialogue_resource, dialogue_title)
