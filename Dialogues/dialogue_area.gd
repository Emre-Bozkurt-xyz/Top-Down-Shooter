extends Area2D

@export var oneshot: bool
@export var dialogue_resource: Resource
@export var dialogue_title: String

var disabled: bool = false

func _ready() -> void:
	area_entered.connect(on_area_entered)

func on_area_entered(area: Area2D):
	Global.current_level_manager.beginDialogue(dialogue_resource, dialogue_title)
	
	if oneshot:
		queue_free()
