extends Node3D

var is_active: bool:
	set(input):
		#print("is active: ", is_active)
		is_active = input
		if (is_active == false):
			ready_stab = false 
@onready var anim_player = $AnimationPlayer
@onready var hit_ray = $HitDetectionRay
@onready var slash_noise = $SlashNoise
@onready var stab_noise = $StabNoise
var ready_stab: bool = false:
	set(input):
		ready_stab = input
		if (ready_stab == true):
			if (anim_player.current_animation != "prep"):
				anim_player.play("prep")
		else:
			if (anim_player.current_animation != "stab"):
				anim_player.play("unprep")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if hit_ray.is_colliding():
		var target = hit_ray.get_collider()
		if (target.is_in_group("Pedestrian")):
			var enemy_to_player = target.global_position.direction_to(self.global_position)
			
			##find the dot function!
			
			var dot_product = acos(enemy_to_player.dot(Vector3.FORWARD))
			if (dot_product <= deg_to_rad(75)):
				#print(dot_product)
				#print("ready to stab")
				if (ready_stab != true):
					ready_stab= true
			else:
				if (ready_stab != false):
					ready_stab = false
	else:
		if (ready_stab != false):
			ready_stab = false

func hit():
	if ((anim_player.current_animation != "slash") and (anim_player.current_animation != "stab")):
		if (!ready_stab):
			print("slash!")
			slash()
		else:
			stab()

func slash():
	##print("slash!")
	slash_noise.playing = true
	anim_player.play("slash")
	if (hit_ray.is_colliding()):
		var target  = hit_ray.get_collider()
		var col_point = hit_ray.get_collision_point() 
		if (target.is_in_group("Pedestrian")):
			target.take_dmg(15, col_point.direction_to(target.position))

func stab():
	stab_noise.playing = true
	anim_player.play("stab")
	if (hit_ray.is_colliding()):
		var target  = hit_ray.get_collider()
		var col_point = hit_ray.get_collision_point() 
		if (target.is_in_group("Pedestrian")):
			target.take_dmg(100, col_point.direction_to(target.position))
