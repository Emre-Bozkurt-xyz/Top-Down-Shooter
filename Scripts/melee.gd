class_name Melee
extends Weapon

@export var attack_range: float = 20

@export var attack_range_area: Area2D

var direction: Vector2

func _ready():
	direction = Vector2.RIGHT.rotated(global_rotation)
	
	attack_range_area.get_child(0).shape.radius = attack_range


func attack():
	for area in attack_range_area.get_overlapping_areas():
		if area is HurtBox and !area.is_in_same_group(weapon_owner.get_groups()[0]):
			area.get_hurt(base_damage, weapon_owner, knockback_strength, direction)
