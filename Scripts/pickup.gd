class_name Pickup
extends RigidBody2D

var actionable: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.name == "Actionable":
			child.action_signal.connect(on_player_interaction)
			actionable = child
			break


func on_player_interaction(player):
	queue_free()


func set_texture(texture):
	%Sprite2D.texture = texture


func resize_sprite(scale: float):
	%Sprite2D.scale = Vector2(scale, scale)
