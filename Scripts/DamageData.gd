class_name DamageData extends Node

var physical_damage: Damage
var cold_damage: Damage
var fire_damage: Damage
var lightning_damage: Damage
var poison_damage: Damage
var chaos_damage: Damage

var damage_dealer: Entity
var crit_chance: float
var crit_damage: float
var knockback: float

func _init(_owner, damage_min, damage_max, crit_chance, crit_damage, knockback):
	physical_damage = Damage.new(damage_min, damage_max)
	
