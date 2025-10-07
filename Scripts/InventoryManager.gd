class_name InventoryManager
extends Node

@export_category("Weapons")
@export var weapon_slots: Array[PackedScene]

@export var base_pickup_scene: PackedScene

@export var gun_parent: Node2D

var current_inv_slot
var current_item

var item_stack: Array

var can_drop: bool = true

@onready var inventory_owner = get_parent()

signal item_switched(item)
signal item_state_changed()

func _ready():
	for weapon in weapon_slots:
		var new_weapon = weapon.instantiate()
		item_stack.push_back(new_weapon)
	
	call_deferred("equip", 0)

func equip(id):
	if gun_parent.get_children() and gun_parent.get_child(0):
		current_item.exit()
		
		# Must make this better soon lol
		await current_item.can_exit
		
		gun_parent.remove_child(current_item)
	
	if !item_stack.is_empty():
		gun_parent.add_child(item_stack[id])
	
		current_inv_slot = id
		current_item = item_stack[id]
		item_switched.emit(current_item)
		
		if current_item is Gun:
			current_item.ammo_changed.connect(func(): item_state_changed.emit())
			
		current_item.weapon_owner = inventory_owner
		current_item.enter()

func _unhandled_input(event):
	if event.is_action_pressed("inv_up"):
		if current_inv_slot == 0:
			return
		
		equip(current_inv_slot - 1)
	
	if event.is_action_pressed("inv_down"):
		if current_inv_slot == item_stack.size()-1:
			return
		
		equip(current_inv_slot + 1)
	
	if event.is_action_pressed("drop"):
		drop(current_item)


func drop(item):
	
	if item_stack.size() > 0:
		var pickup_scene : ItemPickup = base_pickup_scene.instantiate()
		
		pickup_scene.set_item(current_item, 0.4)
		pickup_scene.global_position = %DropPosition.global_position
		
		# Need to add a target that takes the position of the mouse pos
		# for the player script to integrate this inventory manager with enemies.
		pickup_scene.apply_momentum(1.5 * 
		inventory_owner.global_position.direction_to(inventory_owner.get_global_mouse_position()))
		
		get_tree().get_root().add_child(pickup_scene)
	
		var temp = current_inv_slot
		if current_inv_slot == item_stack.size() - 1 and current_inv_slot != 0: current_inv_slot -= 1
		item_stack.pop_at(temp)
		equip(current_inv_slot)


func add_item(item):
	var should_switch = true if item_stack.is_empty() else false
	
	item_stack.push_back(item)
	
	if should_switch:
		equip(0)
