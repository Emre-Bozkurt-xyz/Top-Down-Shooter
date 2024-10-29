extends Node

class Rarity:
	var color: Color = Color.WHITE_SMOKE
	var rarity_mult: float
	
	func _init(new_color: Color, new_rarity_mult: float):
		color = new_color
		rarity_mult = new_rarity_mult

var LEGENDARY = Rarity.new(Color.GOLD, 1.9)
var EPIC = Rarity.new(Color.PURPLE, 1.5)
var RARE = Rarity.new(Color.DEEP_SKY_BLUE, 1.2)
var UNCOMMON = Rarity.new(Color.LIME_GREEN, 1)
var COMMON = Rarity.new(Color.WHITE_SMOKE, 0.8)
