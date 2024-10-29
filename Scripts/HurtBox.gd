class_name HurtBox
extends Area2D

@onready var parent = self.get_parent()

func get_hurt(damage, damage_dealer: Node2D = null, knock_back_strength: float = 0, knockback_direction: Vector2 = Vector2.ZERO):
	parent.handle_hit(damage, damage_dealer, knock_back_strength, knockback_direction)


func is_in_same_group(group: String) -> bool:
	return true if parent.get_groups().has(group) else false
