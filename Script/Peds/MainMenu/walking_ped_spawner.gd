extends Node3D

var walking_ped = preload("res://prefabs/MainMenu/menu_walking_ped.tscn")
@onready var timer = $Timer
var last_ped_spawned
@onready var col_sphere = $col_check
@onready var col_shape = $col_check/CollisionShape3D
@onready var raycasts = $Raycasts
var dont_spawn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_walking_ped():
	var ped_to_spawn = walking_ped.instantiate()
	ped_to_spawn.transform = self.transform
	ped_to_spawn.rotate_y(deg_to_rad(90))
	ped_to_spawn.top_level = true
	last_ped_spawned = ped_to_spawn
	get_tree().root.add_child(ped_to_spawn)
	
func recalc_placement():
	var current_pos = global_position.x
	var new_pos = randf_range(-5,5)
	global_position.x = new_pos
	for raycast in raycasts.get_children():
		while (raycast.is_colliding()):
			#print("recalc")
			new_pos = randf_range(-5,5)
			global_position.x = new_pos
			await get_tree().process_frame
	
	#print("found a spot!")

func _on_timer_timeout() -> void:
	recalc_placement()
	spawn_walking_ped()
	timer.start(.5)
