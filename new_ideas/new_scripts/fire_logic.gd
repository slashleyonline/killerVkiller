extends Node3D

@export var bullet_scene_path: String

@onready var bullet_node = load(bullet_scene_path)

func fire(bullet_spawn: Node3D):
	#print("firing bullet!")
	#need to reimplement the movement penalty
	
	if bullet_scene_path != null:
		var bullet_to_spawn = bullet_node.instantiate()
		
		bullet_to_spawn.global_transform = bullet_spawn.global_transform
		bullet_to_spawn.rotation = Vector3(bullet_spawn.global_rotation.x, #+ bullet_dir.x, 
		bullet_spawn.global_rotation.y, 0) # + bullet_dir.y, 0)
		
		bullet_spawn.add_child(bullet_to_spawn)
