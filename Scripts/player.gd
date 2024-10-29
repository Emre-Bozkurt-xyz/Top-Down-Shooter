class_name Player
extends Entity

signal health_changed(current_health)
signal energy_shield_changed(current_energy_shield)

@onready var axis := Vector2.ZERO

@export var move_speed := 100.0

@export_range(-1,1) var starting_direction: int = 1

@onready var actionable_finder = %ActionableFinder

@onready var animation_tree := $AnimationTree
@onready var anim_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@onready var pivot = %Pivot
@onready var gun_holder := %Gun

enum LOOK_DIRECTION {
	RIGHT = 1,
	LEFT = -1
}

var look_direction = LOOK_DIRECTION.RIGHT

func _ready():
	
	super()
	update_animation_parameters(Vector2(starting_direction, 0))


func handle_hit(damage: int, _damage_dealer: Node2D = null, knock_back_strength: float = 0, knockback_direction: Vector2 = Vector2.ZERO):
	super(damage)
	health_changed.emit(health)
	energy_shield_changed.emit(current_energy_shield)

# Possible improvement: signals sent out from base entity class are watched out for in here.
# Might cause performance issues if not necessary.
func recharge_eshield():
	super()
	energy_shield_changed.emit(current_energy_shield)


func regenerate_health():
	super()
	health_changed.emit(health)


func _physics_process(delta):
	move(delta)
	
	pivot.look_at(get_global_mouse_position())
	
	if get_global_mouse_position().x > global_position.x:
		look_direction = LOOK_DIRECTION.RIGHT
	else:
		look_direction = LOOK_DIRECTION.LEFT
	
	if Input.is_action_pressed("fire"):
		if gun_holder.get_child(0):
			gun_holder.get_child(0).attack()
	
	if Input.is_action_pressed("reload"):
		if gun_holder.get_child(0):
			gun_holder.get_child(0).reload()
	
	if Input.is_action_just_pressed("interact"):
		# It is important that actionables are in their own designated layer for this to work
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action(self)
			return


func update_animation_parameters(move_input: Vector2):
	#if move_input.x != 0.0:
	
	animation_tree.set("parameters/Idle/blend_position", look_direction)
	animation_tree.set("parameters/Walk/blend_position", look_direction)


func pick_new_state():
	if velocity != Vector2.ZERO:
		anim_state_machine.travel("Walk")
	else:
		anim_state_machine.travel("Idle")


func get_input_axis():
	axis.x = int(Input.get_action_strength("right")) - int(Input.get_action_strength("left"))
	axis.y = int(Input.get_action_strength("down")) - int(Input.get_action_strength("up"))
	return axis.normalized()


func move(_delta):
	axis = get_input_axis()
	
	velocity = axis * move_speed
	
	update_animation_parameters(axis)
	
	pick_new_state()
	
	move_and_slide()
