class_name LevelManager
extends Node

# Purpose: to handle hardware changes of cursor

var game_cursor = preload("res://Assets/Crosshairs/in_game.png")

var tween: Tween

func _ready():
	Global.current_level_manager = self
	
	take_aim()


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
