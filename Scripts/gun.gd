class_name Gun
extends Weapon

signal ammo_changed
signal can_exit

@export_category("Gun Stats")
@export var maximum_ammo: int = 1
@onready var current_ammo: int = maximum_ammo

@export var reload_time: float = 1
@export var firerate: float = 1
@export var accuracy: float = 10
var accuracy_mult: float = 2.5
@export var number_of_shots: int = 1
@export var number_of_bullets: int = 1
@export_range(0, 360) var arc: float = 20

@export_group("Bullet settings")

@export var bullet_speed: float = 10

enum BULLET_DECAY_TYPE {
	RANGE,
	TIME
}

@export var bullet_decay: BULLET_DECAY_TYPE
@export var decay_value: float = 1000
@export var bullet_penetration: int = 1

@export_category("Resources")
@export var bullet: PackedScene
@export var barrel_pos: Node2D

@export var muzzle_flash: PackedScene

var can_fire: bool = true

var multi_shot_delay: float = 0.05

@onready var sprite := %BodySprite
@onready var animation_player = %AnimationPlayer

# States enum
enum {
	READY,
	FIRING,
	RELOADING,
	ANIMATING
}

var state = READY

func enter():
	state = ANIMATING
	animation_player.play("Enter")
	await animation_player.animation_finished
	state = READY


func exit():
	state = ANIMATING
	animation_player.play("Exit")
	await animation_player.animation_finished
	can_exit.emit()
	state = READY


func attack():
	if state == READY:
		state = FIRING
		if current_ammo != 0:
			if weapon_owner is Player:
				current_ammo -= 1
				camera_shake()
			
			animation_player.play("Fire")
			
			ammo_changed.emit()
			
			shoot_bullets(number_of_shots)
		
		# Auto-reload while fire action is pressed and no more ammo
		else:
			reload()
			return
		
		# Firerate handling, will skip the wait if there are no more bullets
		# for better feeling auto-reload while fire action is pressed
		if current_ammo > 0: await get_tree().create_timer(1 / firerate).timeout
		
		# Band-aid solution for firing while reload action is held down causing
		# two immediate successions of shots to be fired
		if !reloading: state = READY


func shoot_bullets(shots):
	# Multi-shot handling
	for i in shots:
		
		# Multi-bullet per shot handling
		for j in number_of_bullets:
			var new_bullet = bullet.instantiate()
			new_bullet.initialize(bullet_speed, decay_value, base_damage.value, weapon_owner, knockback.value, bullet_penetration)
			
			if bullet_decay == BULLET_DECAY_TYPE.RANGE:
				new_bullet.decay_type = "Range" 
			elif bullet_decay == BULLET_DECAY_TYPE.TIME: 
				new_bullet.decay_type = "Time" 
			
			new_bullet.global_position = barrel_pos.global_position if barrel_pos else global_position
			
			# Spooky arc rotation stuff for bullet
			if number_of_bullets == 1:
				new_bullet.global_rotation = global_rotation + deg_to_rad(randf_range(((10 - accuracy) * accuracy_mult), -((10 - accuracy) * accuracy_mult)))
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (number_of_bullets-1)
				new_bullet.global_rotation = (
					global_rotation + deg_to_rad(randf_range(((10 - accuracy) * accuracy_mult), 
					-((10 - accuracy) * accuracy_mult))) + 
					increment * j - 
					arc_rad / 2
				)
			
			get_tree().root.add_child(new_bullet)
		
		if number_of_shots > 1:
			await get_tree().create_timer(multi_shot_delay).timeout


var reloading = false
func reload():
	
	if !reloading and current_ammo < maximum_ammo:
		state = RELOADING
		reloading = true
		
		Global.current_level_manager.reload()
		await get_tree().create_timer(reload_time).timeout
		Global.current_level_manager.take_aim()
		
		current_ammo = maximum_ammo
		ammo_changed.emit()
		
		reloading = false
		state = READY
	


func camera_shake():
	var camera = get_viewport().get_camera_2d().shake(camera_shake_strength / 10)


func get_texture():
	return %BodySprite.texture
