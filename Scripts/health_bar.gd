extends HBoxContainer

@onready var timer := %Timer
@onready var damage_bar := %DamageBar
@onready var health_bar = %HealthBar
@onready var energy_shield_bar = %EnergyShieldBar

var health = 0: set = set_health
var energy_shield = 0: set = set_energy_shield

func set_health(new_health):
	var previous_health = health
	health = min(health_bar.max_value, new_health)
	health_bar.value = health
	
	if health < previous_health:
		timer.start()
	else:
		damage_bar.value = health
	
	await get_tree().physics_frame
	if health != health_bar.max_value:
		visible = true

func init_health(_health, _energy_shield):
	visible = false
	health = _health
	health_bar.max_value = health
	health_bar.value = health
	damage_bar.max_value = health
	damage_bar.value = health
	
	energy_shield = _energy_shield
	energy_shield_bar.max_value = energy_shield
	energy_shield_bar.value = energy_shield
	
	if energy_shield_bar.max_value == 0:
		energy_shield_bar.visible = false

func set_energy_shield(new_energy_shield):
	energy_shield = min(energy_shield_bar.max_value, new_energy_shield)
	energy_shield = new_energy_shield
	energy_shield_bar.value = energy_shield
	
	await get_tree().physics_frame
	if energy_shield != energy_shield_bar.max_value:
		visible = true

func _on_timer_timeout():
	damage_bar.value = health
