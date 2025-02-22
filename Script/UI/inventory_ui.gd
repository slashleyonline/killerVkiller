extends Control

@onready var container = $HBoxContainer
@onready var ui_slots: Array = container.get_children()

var prefab_slot = preload("res://prefabs/UI/UISlot.tscn")

var current_item_index

func select_current_item_slot(index: int):
	if index < 4:
		#print("selecting item at index ", index)
		ui_slots[index].is_selected = true
		current_item_index = index

func deselect_current_item_slot(index: int):
	ui_slots[index].is_selected = false

func search_item_slot(item_data: Item):
	#print("searching for: ", item_data.title)
	for idx: int in ui_slots.size():
		#print("loop!")
		if ui_slots[idx].item_slot != null:
			print(ui_slots[idx].item_slot.title)
			if item_data.title == ui_slots[idx].item_slot.title:
				#print("found!")
				return idx
	return 0

func deactivate_active():
	for idx: int in ui_slots.size():
		if ui_slots[idx] != null:
			deselect_current_item_slot(idx)

func select_by_search(item_data: Item):
	#print("searching ", item_data.title)
	deactivate_active()
	#print("searching for: ", item_data.title)
	for idx: int in ui_slots.size():
		#print("loop!")
		if ui_slots[idx].item_slot != null:
			#print(item_data.title, " - ", ui_slots[idx].item_slot.title)
			if item_data.title == ui_slots[idx].item_slot.title:
				select_current_item_slot(idx)
				return
	#print("item not found!")

func add_item_to_ui(new_item):
	var open_slot
	var slot_found = false
	
	for slot in ui_slots:
		if slot.item_title == "None":
			open_slot = slot
			open_slot.item_slot = new_item
			open_slot.is_selected = false
			slot_found = true
		if slot_found:
			break
	
	if !slot_found:
		print("inventory full!")
	else:
		pass
		#print(new_item.title, " added to inventory!")

func clear_ui(item: Item):
	#print("calling clear ui")
	for slot in ui_slots:
		if item.title == slot.item_title:
			#print("found item!")
			slot.is_empty = true

func create_ui_slot(data: Item):
	#ui_slots = container.get_children()
	var slot_to_create = prefab_slot.instantiate()
	slot_to_create.item_slot = data
	container.add_child(slot_to_create)
	
	ui_slots = container.get_children()

func remove_ui_slot(data: Item):
	#ui_slots = container.get_children()
	#print("size is: ", ui_slots.size())
	#deactivate_active()
	
	for index in ui_slots.size():
		if ui_slots[index].item_slot.title == data.title:
			var item_to_rem = ui_slots[index]
			ui_slots.remove_at(index)
			container.remove_child(item_to_rem)
			item_to_rem.queue_free()
			#print("removing item!")
			break
	ui_slots = container.get_children()
	#select_current_item_slot(0)
	#ui_slots.resize(ui_slots.size())
	#print("size is: ", ui_slots.size())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#print("size is: ", ui_slots.size())
	#ui_slots[0].is_empty = false

func _process(delta: float) -> void:
	pass
	#print("size is: ", ui_slots.size())
