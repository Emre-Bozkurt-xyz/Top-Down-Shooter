class_name LevelManager
extends Node

# Purpose: to handle hardware changes of cursor

@export var dialogue_resource: Resource = null
@export var dialogue_title: String = "start"

var game_cursor = preload("res://Assets/Crosshairs/in_game.png")

var tween: Tween

func _ready():
	Global.current_level_manager = self
	Global.interaction_began.connect(on_interaction_began)
	Global.interaction_completed.connect(on_interaction_completed)
	call_deferred("beginDialogue", dialogue_resource, dialogue_title)

func beginDialogue(resource: Resource, title: String):
	DialogueManager.show_dialogue_balloon_scene("res://Dialogues/example_balloon.tscn", resource, title)

func on_interaction_began(args: Array):
	Input.set_custom_mouse_cursor(null)
	Global.can_player_action = false
	Global.can_player_move = false
	Global.enemies_paused = true

func on_interaction_completed(args: Array):
	take_aim()
	await get_tree().create_timer(0.1).timeout
	Global.can_player_action = true
	Global.can_player_move = true
	Global.enemies_paused = false

func reload():
	
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween().set_loops()
	tween.tween_callback(reload_iterator).set_delay(0.1)


var reload_index: int = 0
func reload_iterator():
	if reload_index == 3:
		reload_index = 0
	else:
		reload_index += 1
	
	var frame = load("res://Assets/Crosshairs/Reload/frame" + str(reload_index) + ".png")
		
	Input.set_custom_mouse_cursor(
		frame, Input.CURSOR_ARROW, Vector2(32, 32)
	)


func take_aim():
	if tween:
		tween.kill()
	
	Input.set_custom_mouse_cursor(
		game_cursor, Input.CURSOR_ARROW, Vector2(32, 32)
	)
