extends Node

class_name Item

@export var title: String:
	set(input):
		title = input
@export var icon: CompressedTexture2D
@export var weapon_scene: String:
	set(path): 
		weapon_scene = path
@export var pickup_scene: String
@export var is_gun: bool

func get_item():
	var item_return: Item = Item.new()
	item_return.title = title
	item_return.icon = icon
	item_return.weapon_scene = weapon_scene
	item_return.pickup_scene = pickup_scene
	item_return.is_gun = is_gun
	
	return item_return
