extends Pickup

@export var property_to_modify: String
@export var value: float
@export_enum("Set", "Add", "Subtract", "Multiply") var operation

func on_player_interaction(player):
	var held_item = player.get_node("InventoryManager").current_item
	if held_item is Gun:
		match operation:
			0: held_item.set(property_to_modify, value)
			1: held_item.set(property_to_modify, held_item.get(property_to_modify) + value)
			2: held_item.set(property_to_modify, held_item.get(property_to_modify) - value)
			3: held_item.set(property_to_modify, held_item.get(property_to_modify) * value)
	
	super(player)
