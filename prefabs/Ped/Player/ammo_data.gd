extends Node

class_name AmmoData
"""
var item:
	set(input):
		item = input
"""
var ammo: int = 0:
	set(amount):
		ammo = amount
		#print("ammo set to ", ammo)
		"""
		if item.name == "RevolverWeapon":
			item.ammo_total = amount
			return
		elif item.name != "RevolverWeapon":
			var starter = get_parent().get_node("Starter")
			for items in starter.get_children():
				if items.name == "RevolverWeapon":
					items.ammo_total = ammo
					return
		"""
var mag: int = 0:
	set(amount):
		mag = amount
		spent_bullets = 6 - amount
		#print("mag set to ", amount)
var spent_bullets: int = 0
var needed_ammo: int = 0:
	set(amount):
		needed_ammo = amount
		send_needed_ammo.emit(amount)

signal send_needed_ammo(amount: int)
