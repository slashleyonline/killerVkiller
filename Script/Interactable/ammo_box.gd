extends Node3D
var bullets = 16
@onready var bullet_meshes = $"Bullets"
@onready var anim_player = $"_357 AmmoBox/AnimationPlayer"
@onready var box_col = $box_col

var is_open = false
var can_open = true

func open():
	if is_open == false:
		anim_player.play("Open")
		is_open = true
		can_open = false
		

func take_bullets(amount: int):
	var bullets_to_remove = bullet_meshes.get_children()
	var bullet_remove_index: int = 0
	
	print(bullets_to_remove.size())
	print("index: ", bullet_remove_index)

	var bullets_taken = 0
	if bullets != 0:
		for i in amount:
			if bullets == 0:
				break
			print(bullets_to_remove[bullet_remove_index].name)
			bullets_to_remove[bullet_remove_index].queue_free()
			bullets -= 1
			bullets_taken += 1
			bullet_remove_index = i + 1
		
		print("Took ", bullets_taken, " bullets, ", bullets, " left")
	return bullets_taken
