class_name Entity
extends CharacterBody2D

signal died

@export var max_health: float = 100:
	set(value):
		max_health = max(0, value)
		
		if health > max_health:
			health = max_health
		
		# Updates the 'pure' recharge amount
		health_regen_amount = max_health * health_regen_percent

var health: float = max_health:
	set(value):
		health = max(0, value)
		
		if health <= 0:
			die()

@export var health_regen_rate: float = 10:
	set(value):
		health_regen_rate = value
		# Re-setting the tween with the new recharge rate
		if health_regen_tween:
			health_regen_tween.kill()
		
		health_regen_tween = get_tree().create_tween().set_loops()
		health_regen_tween.bind_node(self)
		health_regen_tween.tween_callback(regenerate_health).set_delay(1/health_regen_rate)

@export_range(0.0, 1.0) var health_regen_percent: float = 0:
	set(value):
		health_regen_percent = value
		
		health_regen_amount = max_health * health_regen_percent

var health_regen_amount: float = 0
@export var health_regen_additional_amount: float = 0

var health_regen_tween


# Damage mitigation TBC
@export var armor: int = 0

# Chance to dodge
@export var dexterity: int = 0:
	set(value):
		dexterity = value
		dodge_chance = clampf(dodge_chance/10, 0.0, 0.8)
var dodge_chance: float = 0

# Energy shield

@export_group("Energy Shield Settings")
# Temporary health which refills
@export var max_energy_shield: float = 0:
	set(value):
		max_energy_shield = value
		
		# Updates the 'pure' recharge amount
		eshield_recharge_amount = max_energy_shield * eshield_recharge_amount_percent

@onready var current_energy_shield: float = max_energy_shield


@export var should_recharge_energy_shield: bool = true

@export_subgroup("Recharge Settings", "eshield_recharge_")
# How often does it recharge, or {the rate} recharges per second
@export var eshield_recharge_rate: float = 10:
	set(value):
		eshield_recharge_rate = value
		# Re-setting the tween with the new recharge rate
		if eshield_tween:
			eshield_tween.kill()
		
		eshield_tween = get_tree().create_tween().set_loops()
		eshield_tween.bind_node(self)
		eshield_tween.tween_callback(recharge_eshield).set_delay(1/eshield_recharge_rate)

# How much does it recharge every time
var eshield_recharge_amount: float = 0
# Calculated in addition to the above
@export var eshield_recharge_additional_amount: float = 0
# How much the energy shield points influence the recharge amount
@export_range(0.0, 1.0) var eshield_recharge_amount_percent: float = 0.05:
	set(value):
		eshield_recharge_amount_percent = value
		
		eshield_recharge_amount = max_energy_shield * eshield_recharge_amount_percent


var eshield_tween

# Length, in seconds, of delay after getting hit for recharging to kick in
@export var eshield_recharge_delay: float = 1.5
# Boolean is turned off when getting hit, timer turns it back on
# recharging method only works when boolean is true
var eshield_after_hit_delay_timer := Timer.new()
var can_recharge_energy_shield = true

func _ready():
	initialize()


func regenerate_health():
	if health < max_health:
		var final_amount = health_regen_amount + health_regen_additional_amount
		health = (health + final_amount) if health + final_amount < max_health else max_health


func recharge_eshield():
	if can_recharge_energy_shield and current_energy_shield < max_energy_shield:
		var final_amount := eshield_recharge_amount + eshield_recharge_additional_amount
		current_energy_shield = (current_energy_shield + final_amount) if current_energy_shield + final_amount < max_energy_shield else max_energy_shield


func handle_hit(raw_damage: int, _damage_dealer: Node2D = null, 
				_knock_back_strength: float = 0, _knockback_direction: Vector2 = Vector2.ZERO):
	var damage_dealt: float
	if randf() < dodge_chance:
		return
	else:
		# https://www.poewiki.net/wiki/Armour
		damage_dealt = raw_damage
		#(5 * pow(raw_damage, 2)) / (armor + 5 * raw_damage)
		if current_energy_shield >= damage_dealt:
			current_energy_shield -= damage_dealt
		elif current_energy_shield > 0:
			damage_dealt -= current_energy_shield
			current_energy_shield = 0
			health -= damage_dealt
		else:
			health -= damage_dealt
		
		# So that energy shield recharge starts after a short delay
		if !eshield_after_hit_delay_timer.is_stopped():
			eshield_after_hit_delay_timer.stop()
		
		if should_recharge_energy_shield: 
			can_recharge_energy_shield = false
			eshield_after_hit_delay_timer.start()


func initialize():
	# Creating tween to repeatedly call the recharge function
	if eshield_tween:
		eshield_tween.kill()
	
	eshield_tween = get_tree().create_tween().set_loops()
	eshield_tween.bind_node(self)
	eshield_tween.tween_callback(recharge_eshield).set_delay(1/eshield_recharge_rate)
	
	if health_regen_tween:
		health_regen_tween.kill()
	
	health_regen_tween = get_tree().create_tween().set_loops()
	health_regen_tween.bind_node(self)
	health_regen_tween.tween_callback(regenerate_health).set_delay(1/health_regen_rate)
	
	# Setting up timer for delayed recharge handling and adding it as a child of entity node
	eshield_after_hit_delay_timer.wait_time = eshield_recharge_delay
	eshield_after_hit_delay_timer.one_shot = true
	eshield_after_hit_delay_timer.timeout.connect(func(): can_recharge_energy_shield = true)
	add_child(eshield_after_hit_delay_timer)


func die():
	died.emit()
	queue_free()
