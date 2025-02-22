extends RayCast3D

@onready var inv = get_parent().get_node("Inventory")

signal pickup_item(new_item: Pickup)
signal add_ammo(amount: int, type : String)
signal check_item(title: String)


var rev_needed_ammo: int

var inv_size: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_colliding():
		if Input.is_action_just_pressed("interact"):
			var interactable = get_collider()
			if interactable.is_in_group("pickup"):
				var check = check_pickup(interactable.title)
				if !check:
					print("inventory already contains ", interactable.title, ", switching....")
					inv.swap_items(interactable.item_pickup)
					interactable.remove_pickup()
				else:
					if inv_size < 4:
						pickup_item.emit(interactable)
						interactable.remove_pickup()
					else:
						print("too many items!")
			elif interactable.is_in_group("ammo_box"):
				var box = interactable.get_parent()
				if box.is_open == false:
					box.open()
				else:
					print("needed ammo: ", rev_needed_ammo)
					if interactable.is_in_group("revolver") and rev_needed_ammo > 0:
						var ammo_taken = interactable.get_parent().take_bullets(rev_needed_ammo)
						add_ammo.emit(ammo_taken, "revolver")
						rev_needed_ammo = 0
			elif interactable.is_in_group("item_box"):
				var cur_item = self.owner.current_item
				if cur_item.has_method("set_key_color"):
					cur_item.is_used = true
					interactable.owner.attempt_unlock(cur_item.color_str)


func _on_ammo_data_send_needed_revolver_ammo(amount: int) -> void:
	rev_needed_ammo = amount
	#print("needed ammo set to: ", rev_needed_ammo)

func check_pickup(title: String):
	var result = inv.check_inv(title)
	#print("check send: ", result)
	return result
