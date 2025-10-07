extends Node

var current_level_manager: LevelManager

signal interaction_began(args: Array)
signal interaction_completed(args: Array)

var can_player_action: bool = true
var can_player_move: bool = true
var enemies_paused: bool = false

func signal_interaction_began(args: Array = []):
	interaction_began.emit(args)

func signal_interaction_completed(args: Array = []):
	interaction_completed.emit(args)
