extends CharacterBody2D

@export var impact_particle_emitter_scene: PackedScene
@export_color_no_alpha var impact_particle_color

var impact_particle_emitter: GPUParticles2D

var speed: float = 20
var direction = Vector2.RIGHT
var decay_type: String = "Range"
var decay_value: float
var damage: float
var damage_dealer: Entity
var knockback_strength: float
var penetration: int
var penetration_left: int

var timer: SceneTreeTimer

@onready var tree_root := get_tree().get_root()
@onready var detector := %Detector

func initialize(_speed: float, _decay_value: float, _damage: float, _damage_dealer: Entity, _knockback_strength: float, penetration: int = 1):
	speed = _speed
	decay_value = _decay_value
	damage = _damage
	damage_dealer = _damage_dealer
	knockback_strength = _knockback_strength
	penetration = penetration
	penetration_left = penetration


func _ready():
	direction = Vector2.RIGHT.rotated(global_rotation)
	
	if impact_particle_emitter_scene:
		impact_particle_emitter = impact_particle_emitter_scene.instantiate()
		impact_particle_emitter.process_material.color = impact_particle_color
	
	if decay_type == "Time":
		timer = get_tree().create_timer(decay_value)
		timer.timeout.connect(func(): queue_free())
	
	detector.area_entered.connect(on_area_detected)


func on_area_detected(area: Area2D):
	if penetration_left > 0 and area is HurtBox and is_instance_valid(damage_dealer) and !area.is_in_same_group(damage_dealer.get_groups()[0]):
		area.get_hurt(damage, damage_dealer, knockback_strength, direction)
		penetration_left -= 1
		
		if penetration_left == 0:
			queue_free()



func _physics_process(delta):
	velocity = direction * speed
	
	var collision := move_and_collide(velocity)
	
	if collision:
		
		if impact_particle_emitter_scene:
			impact_particle_emitter.emitting = true
			impact_particle_emitter.global_position = collision.get_position()
			impact_particle_emitter.global_rotation = collision.get_normal().angle()
			tree_root.add_child(impact_particle_emitter)
		queue_free()
	
	if decay_type == "Range" and is_instance_valid(damage_dealer) \
	and (abs(global_position.distance_to(damage_dealer.global_position)) >= decay_value):
		queue_free()
