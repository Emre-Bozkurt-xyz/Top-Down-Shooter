class_name EnemyBase
extends Entity

@export_category("Enemy Stats")
@export var movement_speed: float = 50
@export var attack_frequency: float = 1
var attack_tween

@export_category("Attachable Nodes")
@export var navigation_agent: NavigationAgent2D = null
@export var health_bar: Control = null
@export var damage_numbers_origin: Node2D = null
@export var detection_area: Area2D = null
@export var attack_area: Area2D = null

@export_category("Toggle-ables")
@export var can_move: bool = true

@export var follow_target: Node2D = null
@export var attack_target: Node2D = null
@export var should_follow_target: bool = true

@export var can_be_knockbacked: bool = true

@onready var weapon_slot = %Weapon
@onready var pivot = %Pivot

func _ready():
	super()
	if health_bar:
		health_bar.init_health(health, current_energy_shield)
	
	if navigation_agent:
		navigation_agent.connect("velocity_computed", on_navigation_agent_velocity_computed)
	
	if detection_area:
		detection_area.connect("body_entered", on_body_detected_detection_area)
	
	if attack_area:
		attack_area.connect("body_entered", on_body_detected_attack_area)
		attack_area.connect("body_exited", on_body_exited_attack_area)
	
	## If inventory manager for enemies is added, this must move there
	if is_instance_valid(weapon_slot.get_child(0)):
		weapon_slot.get_child(0).weapon_owner = self
	
	# Updates navigation target within short intervals
	get_tree().create_tween().bind_node(self).set_loops().tween_callback(update_navigation_target).set_delay(0.3)

func _physics_process(delta):
	
	if is_instance_valid(attack_target) and attack_target:
		pivot.look_at(attack_target.global_position)
	
	if navigation_agent and should_follow_target:
		if navigation_agent.is_navigation_finished():
			return
		
		var current_agent_position = global_position
		var next_path_position = navigation_agent.get_next_path_position()
		
		var new_velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		if navigation_agent.avoidance_enabled:
			navigation_agent.set_velocity(new_velocity)
		else:
			velocity = new_velocity
	
	if can_move: move_and_slide()


func on_navigation_agent_velocity_computed(safe_velocity):
	velocity = safe_velocity


func update_navigation_target():
	if is_instance_valid(follow_target):
		navigation_agent.target_position = follow_target.global_position


func handle_hit(raw_damage, damage_dealer: Node2D = null, knock_back_strength: float = 0, knockback_direction: Vector2 = Vector2.ZERO):
	super(raw_damage)
	
	if health_bar:
		health_bar.health = health
		health_bar.energy_shield = current_energy_shield
	
	if damage_numbers_origin:
		DamageNumbers.display_number(raw_damage, damage_numbers_origin.global_position, false)
	
	if damage_dealer:
		set_follow_target(damage_dealer)
	
	if can_be_knockbacked:
		get_knocked_back(knock_back_strength, knockback_direction)


func get_knocked_back(knock_back_strength: float, knockback_direction: Vector2):
	should_follow_target = false
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(navigation_agent.get_velocity() + knock_back_strength * 10 * knockback_direction)
	else:
		velocity = velocity + knock_back_strength * 10 * knockback_direction
	
	get_tree().create_timer(0.1).timeout.connect(func(): should_follow_target = true)


func recharge_eshield():
	super()
	health_bar.energy_shield = current_energy_shield


func attack():
	weapon_slot.get_child(0).attack()


func on_body_detected_attack_area(body: Node2D):
	if body.is_in_group("Player"):
		set_attack_target(body)


func on_body_exited_attack_area(body: Node2D):
	if body == attack_target:
		attack_target = null
		
		if attack_tween:
			attack_tween.kill()


func set_attack_target(body):
	if body != attack_target:
		attack_target = body
		
		if attack_tween:
			attack_tween.kill()
		
		attack_tween = get_tree().create_tween().set_loops()
		attack_tween.tween_callback(attack).set_delay(1/attack_frequency)
		
		if is_instance_valid(weapon_slot.get_child(0)):
			weapon_slot.get_child(0).look_at_target = attack_target


func on_body_detected_detection_area(body: Node2D):
	if body.is_in_group("Player"):
		set_follow_target(body)


func set_follow_target(body):
	follow_target = body
		
	for other_body in detection_area.get_overlapping_bodies():
		if other_body.is_in_group("Enemy"):
			other_body.follow_target = follow_target




