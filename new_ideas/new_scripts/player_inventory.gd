extends Node3D

var current_item: Node3D:
	set(input):
		current_item = input
		#set it to true??
@onready var spawn_location = $PickupSpawner
@onready var item_cont = $ItemController
@onready var items_arr = item_cont.get_children()
var can_switch: bool = true

var revolver_bullets = 6
var shotgun_bullets = 0


func add_item(new_item: Item):
	var item_to_inst = load(new_item.weapon_scene)
	if item_to_inst != null:
		item_to_inst = item_to_inst.instantiate()
		item_to_inst.visible = false
		item_cont.add_child(item_to_inst)
		
	#print("adding ", new_item.title)

func drop_item(discard_item: Item):
	var new_pickup = load(discard_item.pickup_scene)
	new_pickup = new_pickup.instantiate()
	new_pickup.global_transform = spawn_location.global_transform
	get_tree().root.add_child(new_pickup)
	
	new_pickup.rotation = Vector3(spawn_location.global_rotation.x, #+ bullet_dir.x, 
		spawn_location.global_rotation.y, 0)
	
	new_pickup.apply_impulse(-new_pickup.transform.basis.z * 10, new_pickup.transform.basis.z, )
	
	#print("removing ", discard_item.title)


func use():
	if current_item.has_method("use"):
		current_item.use(spawn_location)
	##need to update for different types of ammo
	if current_item.has_method("reload"):
		if current_item.get_gun_name() == "Revolver":
			pass
			#update_ammo(current_item.get_current_ammo(), revolver_bullets)
		elif current_item.get_gun_name() == "Shotgun":
			pass
			#update_ammo(current_item.get_current_ammo(), shotgun_bullets)
	elif current_item.has_method("hit"):
		current_item.hit()

func reload():
	if current_item.has_method("reload") && current_item.get_current_ammo() < 6 \
		&& !current_item.check_anim():
			#print("here!")
			var needed_bullets = current_item.get_needed_bullets()
			var current_bullets
			
			if current_item.get_gun_name() == "Revolver":
				current_bullets = revolver_bullets
			elif current_item.get_gun_name() == "Shotgun":
				current_bullets = shotgun_bullets
			
			if current_bullets >= current_item.get_needed_bullets():
				current_item.reload(current_bullets)
				current_bullets -= needed_bullets
				#update_ammo(current_item.get_current_ammo(), current_bullets)
			else:
				#print("revolver bullets: ", current_bullets)
				current_item.reload(current_bullets)
				current_bullets = 0
				#print("revolver bullets set to ", current_bullets)
				#update_ammo(current_item.get_current_ammo(), current_bullets)
			
			if current_item.get_gun_name() == "Revolver":
				revolver_bullets = current_bullets
			elif current_item.get_gun_name() == "Shotgun":
				shotgun_bullets = current_bullets

func get_can_switch():
	return can_switch


func find_item(item_str: String):
	if current_item != null:
		if current_item.name != "Unarmed":
			current_item.visible = false
	
	items_arr = item_cont.get_children()
	for item in items_arr.size():
		print(items_arr[item].name)
		if items_arr[item].name == item_str:
			current_item = items_arr[item]
			current_item.visible = true

"""
func _on_inventory_new_current_item_selected(item: Item) -> void:
	#print("switching to ", item.title)
	if current_item != null:
		if current_item.has_node("Gun/Animation/Mesh/GunAnimation"):
			current_item.set_anim("deactivate")
			await current_item.gun_base.animation.anim.animation_finished
	emit_signal("send_item_for_anim", item.title)
	if inventory == null:
		_ready()
		items_arr = item_holder.get_children()
		current_item = items_arr[0]
	else:
		pass
		#print("setting current item to false!")
		#current_item.is_active = false
	
	#print_items_arr()
	
	#It knows the actual item based on item data. but there is a disconnect between
	#the active item node and the inventory data.
	var item_index = inventory.inv_slots.find(item)
	if current_item != null:
		if replacement_item != null:
			#print("replacement item is: ", replacement_item.title)
			var replace_index = inventory.inv_slots.find(replacement_item)
			#print("found replace index at: ", replace_index)
			#inventory.inv_ui.deselect_current_item_slot(replace_index)
		

		
		current_item.visible = false
		item_index = inventory.inv_slots.find(item)
		#print("current item is ", current_item)
		current_item = items_arr[item_index]
		#print("current item is ", items_arr[item_index])
		
	set_active_item(current_item)
	inventory.inv_ui.select_current_item_slot(item_index)
	replacement_item = item

func print_items_arr():
	for i in items_arr.size():
		print(items_arr[i])

func search_item_array(str: String):
	for i in items_arr.size():
		if items_arr[i].name == str:
			return items_arr[i]

func instantiate_item(pickup: Pickup):
	var new_item = load(pickup.item_pickup.weapon_scene)
	#print("loaded ", pickup.item_pickup.weapon_scene)
	var item_to_spawn = new_item.instantiate()
	
	
	
	item_to_spawn.visible = false
	item_holder.add_child(item_to_spawn)
	
	if pickup.title == "Revolver"\
	or pickup.title == "Shotgun"\
	or pickup.title == "Sniper"\
	or pickup.title == "SMG":
		item_to_spawn.set_ammo(pickup.current_mag_ammo)
	
	items_arr.append(item_to_spawn)

func set_active_item(set_item: Node3D):
	#set_item.is_active = true
	set_item.visible = true
	
	if set_item.has_method("fire"):
		##need to update for different types of ammo!
		update_ammo(current_item.get_current_ammo(), revolver_bullets)
	
	if set_item.has_node("Gun/Animation/Mesh/GunAnimation"):
		set_item.set_anim("activate")
	
	#print("active item is ", set_item.name)

func _on_interact_raycast_pickup_item(new_item: Pickup) -> void:
	if inventory.inv_slots.size() < 4:
		inventory.add_to_inv(new_item.item_pickup)
		interact_ray.inv_size = inventory.item_count
		
		if new_item.item_pickup.title == "Revolver":
			pass
		
		if new_item.item_pickup.title == "Shotgun":
			pass
		
		if new_item.item_pickup.weapon_scene != null:
			instantiate_item(new_item)

func drop_item(item_dropped: Item):
	if item_dropped.title != "Unarmed":
		var pickup = load(item_dropped.pickup_scene)
		var pickup_to_drop = pickup.instantiate()
		
		
		print("dropping ", item_dropped.title)
		
		if item_dropped.title == "Revolver" \
		or item_dropped.title == "Shotgun" \
		or item_dropped.title == "Sniper"\
		or item_dropped.title == "SMG":
			pickup_to_drop.current_mag_ammo = \
			search_item_array(item_dropped.title).get_current_ammo()
			print("ammo set to ", pickup_to_drop.current_mag_ammo)
		
		inventory.remove_from_inv(item_dropped)
		interact_ray.inv_size = inventory.item_count
		
		remove_node_from_arr(item_dropped)
		
		
		if current_item.has_node("Gun"):
			if current_item.get_anim_str() == "deactivate":
				current_item.return_anim_finished()
		
		pickup_to_drop.global_transform = drop_location.global_transform
		get_tree().root.add_child(pickup_to_drop)

func remove_item(delete: Item):
	if delete != null:
		inventory.remove_from_inv(delete)
		interact_ray.inv_size = inventory.item_count
		remove_node_from_arr(delete)
		
		if "anim_player" in current_item:
			if current_item.anim_player.current_animation == "deactivate":
				await current_item.anim_player.animation_finished
	#current_item.is_active = false

func remove_node_from_arr(item_rem: Item):
	#Purpose of this is to remove the desired item 
	#from the array holding all of the weapon scenes.
	for i in items_arr.size():
		print(items_arr[i].name, " - ", item_rem.title)
		if items_arr[i].name == item_rem.title:
			var rem = items_arr[i]
			items_arr.remove_at(i)
			print("removing ", rem.name, " - ", item_rem.title)
			rem.queue_free()
			item_holder.remove_child(rem)
			return
		print(items_arr[i].name)
	#inventory.set_current_item(inventory.current_item_index)

func calc_movement_penalty_TEMPORARY():
	var jump_penalty
	##revolver
	if not is_on_floor():
		#print("firing while jumping!")
		jump_penalty = randi_range(0,1)
		if jump_penalty == 0:
			jump_penalty = -1
	else:
		jump_penalty = 0
	
	var bullet_dir: Vector2
	bullet_dir = Vector2(randf_range(0.01, 0.1) * (randi_range(-1, 1) * (acc_pen + jump_penalty)), 
	(randf_range(0.01, 0.1)) * (randi_range(-1, 1)) * (acc_pen + jump_penalty))
	#print(bullet_dir)
	var spawn_location = $Head/Camera3D/spawnlocation
	var proj_spawn_pos = spawn_location.global_transform
	var loaded_bullet = load(current_item.bullet_scene)
	var bullet_to_add = loaded_bullet.instantiate()
	
	bullet_to_add.global_transform = proj_spawn_pos
	bullet_to_add.rotation = Vector3(spawn_location.global_rotation.x + bullet_dir.x, 
	spawn_location.global_rotation.y + bullet_dir.y, 0)
	
	
	if not is_on_floor():
		#print("firing while jumping!")
		jump_penalty = randi_range(0,1)
		if jump_penalty == 0:
			jump_penalty = -1
	else:
		jump_penalty = 0
	
	 ##shotgun
	var bullets_to_add
	bullets_to_add.global_transform = proj_spawn_pos
	
	for bullet in bullets_to_add.get_children():
		#print ("loop!")
		
		var acc_x = (randf_range(1, 5))
		var neg_pos_x = (randi_range(-1, 1))
		#print(neg_pos_x)
		var acc_y = (randf_range(1, 0.05))
		var neg_pos_y = (randi_range(-1, 1))
		#print(neg_pos_y)
		bullet_dir = Vector2(acc_x * neg_pos_x * (acc_pen + jump_penalty), 
		acc_y * neg_pos_y * (acc_pen + jump_penalty))
		
		bullet.global_rotation_degrees = Vector3(spawn_location.global_rotation.x + bullet_dir.x, 
		spawn_location.global_rotation.y + bullet_dir.y, 0)
	
	add_child(bullets_to_add)
	shot_ammo_data.mag -= 1

func weapon_reload(bullets:int, gun_name: String):
	print("woah")

func check_item(title: String):
	var result = inventory.check_inv(title)
	return result

func swap_items(item: Pickup):
	print("swapping ", item.item_pickup.title)
	var item_to_drop = inventory.search_inv(item.item_pickup)
	print("item to drop is ", item_to_drop.title)
	drop_item(item_to_drop)
	inventory.remove_from_inv(item_to_drop)
	_on_interact_raycast_pickup_item(item)

"""
