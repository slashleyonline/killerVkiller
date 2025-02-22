extends Control

class_name UISlot

@export var item_slot: Item:
	set(new_item):
		item_slot = new_item
		if new_item != null:
			self.item_icon = new_item.icon
			self.item_title = new_item.title
			is_empty= false
		else:
			self.item_icon = null
			self.item_title = "None"
@onready var item_bg = $Icon_slot/UISlot
@export var item_icon: CompressedTexture2D:
	set(new_icon):
		item_icon = new_icon
		if new_icon != null:
			var sprite = $Icon_slot
			sprite.texture = new_icon
			#sprite.modulate.a = global_albedo
var item_title: String = "None"
var is_empty: bool = true:
	set(status):
		is_empty = status
		if status == false:
			self.visible = true
		else:
			self.visible = false
			print(self.visible)
			item_slot = null
			is_selected = false
var is_selected: bool = false:
	set(status):
		is_selected=status
		if is_selected == false:
			alpha = 0.1
		else:
			alpha = 1
var alpha: float:
	set(new_val):
		if self.visible:
			alpha = new_val
			#print("setting alpha to ", global_alpha)
			self.modulate.a = alpha
