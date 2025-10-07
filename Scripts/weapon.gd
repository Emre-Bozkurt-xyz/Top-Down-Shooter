class_name Weapon
extends Node2D

@export_category("Settings")
@export var weapon_name: String
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
var base_damage: FlatStat = FlatStat.new(0)
@export var _base_damage: float:
	set(value):
		base_damage.base_value = value

var crit_chance: PercentStat = PercentStat.new(0)
@export var _crit_chance: float:
	set(value):
		crit_chance.base_value = value

var crit_multiplier: PercentStat = PercentStat.new(0)
@export var _crit_multiplier: float:
	set(value):
		crit_multiplier.base_value = value

@export var camera_shake_strength: float = 0

var knockback: FlatStat = FlatStat.new(0)
@export var _knockback: int = 0:
	set(value):
		knockback.base_value = value

var attack_target: Vector2
var look_at_target: Node2D
var weapon_owner: Node2D

func _physics_process(_delta):
	if not Global.can_player_action: return
	
	if weapon_owner is Player:
		if get_global_mouse_position().x > weapon_owner.global_position.x:
			scale = Vector2(scale.x, abs(scale.y))
		else:
			scale = Vector2(scale.x, -abs(scale.y))
	elif is_instance_valid(look_at_target) and look_at_target:
		if look_at_target.global_position.x > weapon_owner.global_position.x:
			scale = Vector2(scale.x, abs(scale.y))
		else:
			scale = Vector2(scale.x, -abs(scale.y))
