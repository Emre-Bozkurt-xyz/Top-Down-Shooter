class_name ItemPickup extends Pickup

@export var item_scene: PackedScene
@export var item_scale: float = 1

var item

var dir: Vector2

func _ready() -> void:
	super()
	
	if item_scene:
		var new_item = item_scene.instantiate()
		set_item(new_item, item_scale)


func set_item(new_item: Node2D, _scale: float):
	set_texture(new_item.get_texture())
	resize_sprite(_scale)
	apply_rarity(new_item.rarity)
	item = new_item


func on_player_interaction(player):
	player.get_node("InventoryManager").add_item(item)
	
	super(player)


func apply_rarity(rarity: Rarities.Rarity):
	$RarityEmitter.self_modulate = rarity.color


func apply_momentum(momentum: Vector2):
	linear_velocity = momentum


func _physics_process(delta):
	linear_velocity = lerp(linear_velocity, Vector2.ZERO, delta * 5)
	
	move_and_collide(linear_velocity)
