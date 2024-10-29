extends Node

signal action_signal(player)

func action(player):
	action_signal.emit(player)
