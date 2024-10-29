class_name Weapon
extends Node2D

@export_category("Settings")
@export var gun_name: String
@export_enum("Legendary","Epic","Rare","Uncommon","Common") var _rarity :
	set(value):
		if !rarity:
			match value:
				0:
					rarity = Rarities.LEGENDARY
				1:
					rarity = Rarities.EPIC
				2:
					rarity = Rarities.RARE
				3:
					rarity = Rarities.UNCOMMON
				4:
					rarity = Rarities.COMMON

var rarity: Rarities.Rarity

@export_category("Base Stats")
@export var base_damage: float
@export var crit_chance: float
@export var crit_multiplier: float

@export var camera_shake_strength: float = 0
@export var knockback_strength: float = 0

var attack_target: Vector2
var look_at_target: Node2D
var weapon_owner: Node2D
