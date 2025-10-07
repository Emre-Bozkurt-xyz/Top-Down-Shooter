extends StaticBody2D

# TODO: Should turn most of this into a base interactable static body class 
# and keep the case-specific stuff here

@export var base_pickup_scene: PackedScene
@export var item_to_drop: PackedScene

var actionable: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.name == "Actionable":
			child.action_signal.connect(on_player_interaction)
			actionable = child
			break


func set_texture(texture):
	%Sprite2D.texture = texture


func resize_sprite(scale: float):
	%Sprite2D.scale = Vector2(scale, scale)

func on_player_interaction(player):
	actionable.monitorable = false
	actionable.monitoring = false
	
	var pickup_scene: ItemPickup = base_pickup_scene.instantiate()
	var item := item_to_drop.instantiate()
	pickup_scene.set_item(item, 0.45)
	pickup_scene.global_position = global_position
	
	get_tree().create_tween().tween_property(pickup_scene, "global_position:y", -5, 0.2).as_relative().set_ease(Tween.EASE_IN)
	
	get_tree().get_root().add_child(pickup_scene)
