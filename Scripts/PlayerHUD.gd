extends CanvasLayer

@export var inv_manager: InventoryManager
@export var healthbar_container: Control

@onready var ammo_label = %Ammo
@onready var player = owner as Player

var current_item

func _ready():
	inv_manager.item_switched.connect(initialize_item)
	inv_manager.item_state_changed.connect(update_item)
	
	# Need better implementation of this... works fine though
	player.health_changed.connect(func(value): healthbar_container.set_health(value))
	player.energy_shield_changed.connect(func(value): healthbar_container.set_energy_shield(value))
	
	call_deferred("initialize_healthbar")


func initialize_healthbar():
	healthbar_container.init_health(player.health, player.current_energy_shield)


func initialize_item(item):
	current_item = item
	
	ammo_label.text = str(item.current_ammo) + " / " + str(item.maximum_ammo)

func update_item():
	ammo_label.text = str(current_item.current_ammo) + " / " + str(current_item.maximum_ammo)
