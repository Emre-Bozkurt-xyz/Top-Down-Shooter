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

var timer: SceneTreeTimer

@onready var tree_root := get_tree().get_root()


func initialize(_speed: float, _decay_value: float, _damage: float, _damage_dealer: Entity, _knockback_strength: float):
	speed = _speed
	decay_value = _decay_value
	damage = _damage
	damage_dealer = _damage_dealer
	knockback_strength = _knockback_strength


func _ready():
	direction = Vector2.RIGHT.rotated(global_rotation)
	
	if impact_particle_emitter_scene:
		impact_particle_emitter = impact_particle_emitter_scene.instantiate()
		impact_particle_emitter.self_modulate = impact_particle_color
	
	if decay_type == "Time":
		timer = get_tree().create_timer(decay_value)
		timer.timeout.connect(func(): queue_free())

func _physics_process(delta):
	velocity = direction * speed
	
	var collision := move_and_collide(velocity)
	
	if collision:
		var collider := collision.get_collider()
				
		if collider is HurtBox and !collider.is_in_same_group(damage_dealer.get_groups()[0]):
			collider.get_hurt(damage, damage_dealer, knockback_strength, direction)
		elif !collider.get_groups().is_empty() and collider.get_groups()[0] == "Environment":
			print("wall")
		else:
			return
		
		if impact_particle_emitter_scene:
			impact_particle_emitter.emitting = true
			impact_particle_emitter.global_position = collision.get_position()
			impact_particle_emitter.global_rotation = collision.get_normal().angle()
			tree_root.add_child(impact_particle_emitter)
		
		queue_free()
		
	if decay_type == "Range" and ((global_position.length() - damage_dealer.global_position.length()) >= decay_value):
		queue_free()
