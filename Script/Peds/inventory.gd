extends Node

class_name Inventory

signal new_current_item_selected(item: Item)

@onready var inv_slots: Array[Item]
@onready var player_inv = $"Player Inventory"

var revolver_ammo: int
var shotgun_ammo: int
var sniper_ammo: int

var item_count: int
var current_item: Item:
	set(new_current_item):
		current_item= new_current_item
		#print("current item is: ", current_item.title,
		# " at index: ", inv_slots.find(current_item))
		current_item_index = inv_slots.find(current_item)
		inv_ui.select_current_item_slot(current_item_index)
		"""
		if current_item == null:
			inv_ui.select_current_item_slot(current_item_index)
		"""
		
		new_current_item_selected.emit(current_item)
var current_item_index : int

@onready var unarmed = preload("res://Nodes/Items/unarmed.tscn")

@onready var inv_ui = $"Inventory Control/InventoryUI/InventoryControl"

func _ready() -> void:
	var temp = unarmed.instantiate()
	
	add_child(temp)
	add_to_inv(temp.get_item())
	temp.queue_free()
	set_current_item(inv_slots[0])



func ui_set_visible(status: bool):
	inv_ui.visible = status

func print_inv():
	#print("inv size is: ", inv_slots.size())
	#print("You have:")
	for item in inv_slots:
		print(inv_slots.find(item), ": ", item.title)

func check_inv(new_item_title: String):
	for item in inv_slots:
		if item.title == new_item_title:
			#print("You already have ", item.title, "!")
			return false
	#print("You do not have ", new_item_title)
	return true

func add_to_inv(new_item: Item):
	new_item = new_item.duplicate()
	#print("item count is ", item_count)
	if item_count == 4:
		print("Too many items!")
		return
	
	#print("item count is ", item_count)
	if check_inv(new_item.title):
		item_count += 1
		inv_slots.push_back(new_item)
		inv_ui.create_ui_slot(new_item)
		player_inv.add_item(new_item)
		#print_inv()


func select_current_item(increment: int):
	if increment == 1 or increment == -1:
		current_item_index = inv_slots.find(current_item)
		current_item_index += increment
		
		if current_item_index > inv_slots.size() - 1:
			current_item_index = 0
		elif current_item_index == -1:
			current_item_index = inv_slots.size() - 1
		"""
		if inv_ui.ui_slots[current_item_index].visible == false:
			print("slot not visible!")
		"""
		#print("selecting ", current_item.title)
		
		set_current_item(inv_slots[current_item_index])
		inv_ui.select_by_search(current_item)
	else:
		print("invalid increment input! Must be -1 or 1!")

func set_current_item(new_current_item: Item):
	current_item = new_current_item
	player_inv.find_item(new_current_item.title)
	print("switching to: ", current_item.title)


func remove_from_inv(discard: Item):
	if discard.title == "Unarmed":
		print("You can't drop your arms, dumbass.")
		return
	
	if inv_slots.find(discard) == current_item_index:
		#print("carrying switch item! switching to unarmed!")
		set_current_item(inv_slots[0])
	else:
		if !check_inv(discard.title):
			item_count -= 1
		#print("discarding ", discard.title)
		inv_slots.remove_at(inv_slots.find(discard))
		inv_ui.remove_ui_slot(discard)
		discard.queue_free()
		#inv_ui.select_current_item_slot(current_item_index)
	player_inv.drop_item(discard)

func remove_by_title(discard_item: Item):
	var title = discard_item.title
	var item_to_remove
	
	if current_item.title == title:
		#print("carrying switch item! switching to unarmed!")
		set_current_item(inv_slots[0])
	
	for item in inv_slots:
		if item.title == title:
			item_to_remove = item
	
	if item_to_remove == null:
		return
	
	if !check_inv(discard_item.title):
		item_count -= 1
	
	inv_slots.erase(item_to_remove)
	inv_ui.remove_ui_slot(item_to_remove)
	item_to_remove.queue_free()
	
	player_inv.drop_item(discard_item)
	#print_inv()

func drop_current_item():
	if current_item.title != "Unarmed":
		remove_by_title(current_item)
		select_current_item(-1)

func search_inv(item_data: Item):
	for item in inv_slots.size():
		if inv_slots[item].title == item_data.title:
			return inv_slots[item]

func search_by_string(title: String):
	for item in inv_slots.size():
		#print(inv_slots[item].title, " - ", title)
		if inv_slots[item].title == title:
			#print("found item at index ", item)
			return inv_slots[item]


func swap_items(new_item: Item):
	for item in inv_slots.size():
		if inv_slots[item].title == new_item.title:
			remove_from_inv(inv_slots[item])
			add_to_inv(new_item)

func update_ammo(mag: int, ammo: int):
	pass
	#should be a seperate object for UI!
	if  current_item != null and current_item.has_method("use"):
		pass
		#ammo_text.text = str(mag) + "/" + str(ammo)
	else:
		pass
		#ammo_text.text = str(" ")

func get_can_switch():
	return player_inv.get_can_switch()


func use_item():
	if current_item.title != "Unarmed":
		
		player_inv.use()
		pass

func reload():
	pass

func _on_interact_raycast_pickup_item(new_item: Pickup) -> void:
	if check_inv(new_item.title):
		add_to_inv(new_item.item_pickup)
	else:
		swap_items(new_item.item_pickup)

func _on_interact_raycast_add_ammo(amount: int, type: String) -> void:
	if type == "Revolver":
		pass
	elif type == "Shotgun":
		pass
	elif type == "Sniper":
		pass
	elif type == "SMG":
		pass
