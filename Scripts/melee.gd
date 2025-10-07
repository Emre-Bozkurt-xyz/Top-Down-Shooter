class_name Melee
extends Weapon

signal can_exit

@export var attack_range_area: Area2D

@onready var animation_player = $AnimationPlayer
@onready var sprite = %Sprite

var direction: Vector2

# States enum
enum {
	READY,
	ATTACKING,
	ANIMATING
}

enum attack_states {
	READY,
	WAITING,
	NOT_ATTACKING
}

var state = READY
@export var attack_state := attack_states.NOT_ATTACKING
@export var has_animations := false

var attack_speed: FlatStat = FlatStat.new(1)
@export var _attack_speed: float = 1:
	set(value):
		attack_speed.base_value = value


func enter():
	print("entering")
	if has_animations:
		print("playing enter animation")
		state = ANIMATING
		animation_player.play("Enter")
		await animation_player.animation_finished
	state = READY


func exit():
	if has_animations:
		state = ANIMATING
		animation_player.play("Exit")
		await animation_player.animation_finished
	can_exit.emit()
	state = READY
	

func _ready():
	call_deferred("initialize") 


func initialize():
	if has_animations:
		if "idle" in animation_player.get_animation_list():
			animation_player.play("idle")


func attack():
	if state == READY:
		state = ATTACKING
		
		if weapon_owner is Player:
			direction = weapon_owner.global_position.direction_to(get_global_mouse_position())
		elif weapon_owner is EnemyBase and weapon_owner.attack_target:
			direction = weapon_owner.global_position.direction_to(weapon_owner.attack_target.global_position)
		
		if has_animations:
			animation_player.speed_scale = attack_speed.value
			animation_player.play("attack")
			print("Attacking: ", attack_speed.base_value)
			var mem = []
			while animation_player.is_playing():
				await get_tree().create_timer(0.05).timeout
				for area in attack_range_area.get_overlapping_areas():
					if area is HurtBox \
					and !area.is_in_same_group(weapon_owner.get_groups()[0]) \
					and area not in mem \
					and attack_state == attack_states.READY:
						area.get_hurt(base_damage.value, weapon_owner, knockback.value, direction)
						mem.append(area)
			
			animation_player.speed_scale = 1
			
		else:
			for area in attack_range_area.get_overlapping_areas():
					if area is HurtBox \
					and !area.is_in_same_group(weapon_owner.get_groups()[0]):
						area.get_hurt(base_damage.value, weapon_owner, knockback.value, direction)
						
		state = READY


func get_texture():
	return sprite.texture


# TODO: Note to future self, use this to hide certain properties from exports
#func _validate_property(property: Dictionary):
	#if property.name in ["attack_state"]:
		#property.usage = PROPERTY_USAGE_NO_EDITOR
