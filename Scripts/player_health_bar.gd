extends HBoxContainer

@onready var timer := %Timer
@onready var damage_bar := %DamageBar
@onready var health_bar = %HealthBar
@onready var energy_shield_bar = %EnergyShieldBar

var health = 0: set = set_health
var energy_shield = 0: set = set_energy_shield

# Allows smooth movement for setting x_bar values
var damage_bar_tween
var healthbar_tween
var eshield_bar_tween

func set_health(new_health):
	var previous_health = health
	health = min(health_bar.max_value, new_health)
	
	# Tweening
	if healthbar_tween:
		healthbar_tween.kill()
	
	healthbar_tween = get_tree().create_tween()
	healthbar_tween.tween_property(health_bar, "value", health, 0.1)
	
	# If health is regenerating, make the damage bar value match the health
	if health < previous_health:
		timer.start()
	
	if timer.is_stopped():
		_on_timer_timeout()

func init_health(_health, _energy_shield): 
	health = _health
	health_bar.max_value = health
	health_bar.value = health
	damage_bar.max_value = health
	damage_bar.value = health
	
	
	energy_shield = _energy_shield
	energy_shield_bar.max_value = energy_shield
	energy_shield_bar.value = energy_shield

func set_energy_shield(new_energy_shield):
	
	var previous_energy_shield = energy_shield
	energy_shield = min(energy_shield_bar.max_value, new_energy_shield)
	energy_shield = new_energy_shield
	
	# Tweening
	if eshield_bar_tween:
		eshield_bar_tween.kill()
	
	eshield_bar_tween = get_tree().create_tween()
	eshield_bar_tween.tween_property(energy_shield_bar, "value", energy_shield, 0.1)

func _on_timer_timeout():
	if damage_bar_tween:
		damage_bar_tween.kill()
	
	damage_bar_tween = get_tree().create_tween()
	damage_bar_tween.tween_property(damage_bar, "value", health, 0.1)
