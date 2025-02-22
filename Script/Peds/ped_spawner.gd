extends Node3D

@export var ped_base = preload("res://prefabs/Ped/ped_base.tscn")
var new_ped

#ALL RELEVANT RESOURCES FOR COSMETICS PRELOADED INTO THE SPAWNER
@export var dict_hair: Dictionary = {"Combover": preload("res://Resources/Models/Player/Cosmetic/Hair/Combover.tres"),
"FlatTop": preload("res://Resources/Models/Player/Cosmetic/Hair/FlatTop.tres"),
"Long": preload("res://Resources/Models/Player/Cosmetic/Hair/Long.tres"),
"Curly": preload("res://Resources/Models/Player/Cosmetic/Hair/Curly.tres"),
"Bald": preload("res://Resources/Models/Player/Cosmetic/Hair/Bald.tres")}

@export var dict_eyes: Dictionary = {"Angry":preload("res://Resources/textures/Face/Eyes/Angry.png"), 
"Arched":preload("res://Resources/textures/Face/Eyes/Arched.png"), 
"Groggy":preload("res://Resources/textures/Face/Eyes/Groggy.png"),
"Round":preload("res://Resources/textures/Face/Eyes/Round.png")}

@export var dict_mouth: Dictionary = {"Cat":preload("res://Resources/textures/Face/Mouth/Cat.png"),
"Frown":preload("res://Resources/textures/Face/Mouth/Frown.png"),
"Grin":preload("res://Resources/textures/Face/Mouth/Grin.png"),
"Neutral":preload("res://Resources/textures/Face/Mouth/Neutral.png"), 
"Toothy Smile":preload("res://Resources/textures/Face/Mouth/Toothy Smile.png"),
"V":preload("res://Resources/textures/Face/Mouth/V.png")}

@export var dict_shirt: Dictionary = {"CropTop":preload("res://Resources/Models/Player/Cosmetic/Shirts/CropTop.tres"),
"Shirt":preload("res://Resources/Models/Player/Cosmetic/Shirts/Shirt.tres"),
"TankTop":preload("res://Resources/Models/Player/Cosmetic/Shirts/TankTop.tres"),
"Tshirt":preload("res://Resources/Models/Player/Cosmetic/Shirts/Tshirt.tres")}

@export var dict_pants: Dictionary = {"Pants":preload("res://Resources/Models/Player/Cosmetic/Pants/Pants.tres"),
 "Shorts":preload("res://Resources/Models/Player/Cosmetic/Pants/Shorts.tres"),
 "ShortShorts":preload("res://Resources/Models/Player/Cosmetic/Pants/ShortShorts.tres"), 
 "Skirt":preload("res://Resources/Models/Player/Cosmetic/Pants/Skirt.tres")}

@export var dict_shoes: Dictionary = {"Boots":preload("res://Resources/Models/Player/Cosmetic/Shoes/Boots.tres"),
"Loafers":preload("res://Resources/Models/Player/Cosmetic/Shoes/Loafers.tres"),
"Slippers":preload("res://Resources/Models/Player/Cosmetic/Shoes/Slippers.tres"),
"Sneakers":preload("res://Resources/Models/Player/Cosmetic/Shoes/Sneakers.tres")}

@export var dict_skin_color: Dictionary = {
"Beige":preload("res://Resources/Materials/cos_beige.tres"), 
"Light Brown":preload("res://Resources/Materials/cos_sandybrown.tres"), 
"White":preload("res://Resources/Materials/cos_white.tres"), 
"Dark Brown":preload("res://Resources/Materials/cos_skinbrown.tres"), 
"Light Yellow":preload("res://Resources/Materials/cos_lightyellow.tres"), 
"Coral":preload("res://Resources/Materials/cos_coral.tres")}

@export var dict_clothes_color: Dictionary = {
"Crimson":preload("res://Resources/Materials/cos_crimson.tres"), 
"Navy Blue":preload("res://Resources/Materials/cos_navyblue.tres"), 
"Olive Green":preload("res://Resources/Materials/cos_olivegreen.tres"), 
"Black":preload("res://Resources/Materials/cos_black.tres"), 
"Violet":preload("res://Resources/Materials/cos_violet.tres"),
"Neon Green":preload("res://Resources/Materials/cos_neongreen.tres"), 
"Pink":preload("res://Resources/Materials/cos_pink.tres"), 
"Orange":preload("res://Resources/Materials/cos_orange.tres"),
"White":preload("res://Resources/Materials/cos_white.tres"),
"Brown":preload("res://Resources/Materials/cos_brown.tres")}

@export var dict_hair_color: Dictionary = {"Brown":preload("res://Resources/Materials/cos_brown.tres"),
"Navy Blue":preload("res://Resources/Materials/cos_navyblue.tres"),
"Neon Green":preload("res://Resources/Materials/cos_neongreen.tres"), 
"Black":preload("res://Resources/Materials/cos_black.tres"),
"Gray":preload("res://Resources/Materials/cos_hairred.tres"), 
"Red":preload("res://Resources/Materials/cos_hairred.tres"), 
"Blonde":preload("res://Resources/Materials/cos_lightyellow.tres")}

var hair_tex = preload("res://Resources/textures/Hair/White.png")

#arrays for the sake of automation w/ for loops
@export var cos_dict_arr: Array = [dict_hair, dict_shirt, dict_pants, dict_shoes]

@export var color_dict_arr: Array = [dict_hair_color, dict_clothes_color]

@export var face_dict_arr: Array = [dict_eyes, dict_mouth]

@export var regen_ped_enabled = false

signal gen_complete

func _ready():
	create_ped()

func create_ped() -> void:
	#Generates a new pedestrian.
	var new_ped_profile = Pedestrian.new()
	
	new_ped_profile = assign_cosmetics(new_ped_profile)
	new_ped = ped_base.instantiate()
	
	new_ped.assign_profile(new_ped_profile)
	add_child(new_ped)
	gen_complete.emit()


func assign_cosmetics(profile: Pedestrian):
	#Defines all cosmetics in the pedestrian profile.
	profile.skin = generate_skin()
	
	profile.eyes = generate_face(0)
	#print("Eyes generated: ", profile.eyes.title)
	profile.mouth = generate_face(1)
	#print("Mouth generated: ", profile.mouth.title)
	
	profile.hair = generate_cosmetic_mesh(0)
	while (profile.hair.title == profile.skin.title):
		print("same color detected!")
		profile.hair = generate_cosmetic_mesh(0)
	
	profile.shirt = generate_cosmetic_mesh(1)
	while (profile.shirt.title == profile.skin.title):
		print("same color detected!")
		profile.shirt = generate_cosmetic_mesh(1)
	
	profile.pants = generate_cosmetic_mesh(2)
	while (profile.pants.title == profile.skin.title):
		print("same color detected!")
		profile.pants = generate_cosmetic_mesh(2)
	
	profile.shoes = generate_cosmetic_mesh(3)
	while (profile.shoes.title == profile.skin.title):
		print("same color detected!")
		profile.shoes = generate_cosmetic_mesh(3)
	

	
	#print("Ped cosmetic generation complete!")
	return profile

func generate_skin() -> SkinType:
	#generates a random skin type for the ped profile.
	var new_skin = SkinType.new()
	#Issue possibly with the RNG. All characters consistently have the same skin.
	new_skin.title = dict_skin_color.keys()[randi() % dict_skin_color.size()]
	new_skin.material = dict_skin_color.get(new_skin.title)
	
	return new_skin

func generate_face(index: int):
	#generates a random face. If 0, eyes. if 1, mouth
	var new_facial = Facial.new()
	#Issue possibly with the RNG. All characters consistently have the same face.
	new_facial.title = face_dict_arr[index].keys()[randi() % face_dict_arr[index].size()]
	new_facial.texture = face_dict_arr[index].get(new_facial.title)
	
	return new_facial

func generate_cosmetic_mesh(index: int):
	#generates a random cosmetic as well as the corresponding color.
	var new_cos = Cosmetic.new()
	
	new_cos.title = cos_dict_arr[index].keys()[randi() % cos_dict_arr.size()]
	new_cos.model = cos_dict_arr[index].get(new_cos.title)
	var clothes_check = false
	if index >= 1:
		clothes_check = true
	if index != 0:
		index = 1
	
	new_cos.color_title = color_dict_arr[index].keys()[randi() % color_dict_arr[index].size()]
	new_cos.material = color_dict_arr[index].get(new_cos.color_title)
	"""
	if index == 0:
		new_cos.material.albedo_texture = hair_tex
		new_cos.material.albedo_texture_force_srgb = true
	"""
	
	return new_cos

func regen_ped():
	new_ped.queue_free()
	create_ped()

func move_and_delete():
	pass
