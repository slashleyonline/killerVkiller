extends Node3D

class_name Pickup

@export var title: String = self.name
@onready var item_pickup: Item = $ItemData:
	set(new_item):
		item_pickup = new_item
@export var current_mag_ammo: int

@export var key_color_str: String
"""func _ready():
	if item_pickup.is_gun == true and current_mag_ammo == 6:
		ammo_setup()

func ammo_setup():
		if item_pickup.title == "Revolver":
			print("setting revolver ammo")
			current_mag_ammo = 6
			current_total_ammo = 18"""

func remove_pickup():
	queue_free()
