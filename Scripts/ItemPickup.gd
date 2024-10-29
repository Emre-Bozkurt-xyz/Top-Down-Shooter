extends Pickup

var item

var dir: Vector2

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
