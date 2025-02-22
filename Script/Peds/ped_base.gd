extends Node3D

var profile: Pedestrian

@onready var skeleton = $Armature/Skeleton3D
@onready var hair_mesh = $Armature/Skeleton3D/Hair
@onready var shoes_mesh = $Armature/Skeleton3D/Shoes
@onready var shirt_mesh = $Armature/Skeleton3D/Shirt
@onready var pants_mesh = $Armature/Skeleton3D/Pants
@onready var eyes = $Armature/Skeleton3D/Eyes
@onready var mouth = $Armature/Skeleton3D/Mouth
@onready var body = $Armature/Skeleton3D/Body


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh_setup()



func assign_profile(ped_profile: Pedestrian) -> void:
	profile = ped_profile

func set_hair():
	hair_mesh.mesh = profile.hair.model
	hair_mesh.set_surface_override_material(0, profile.hair.material)

func set_shirt():
	shirt_mesh.mesh = profile.shirt.model
	shirt_mesh.set_surface_override_material(0, profile.shirt.material)
	#shirt_mesh.get_active_material(0).albedo_color = profile.shirt_color_asset

func set_pants():
	pants_mesh.mesh = profile.pants.model
	pants_mesh.set_surface_override_material(0, profile.pants.material)
	
	#pants_mesh.get_active_material(0).albedo_color = profile.pants_color_asset

func set_shoes():
	shoes_mesh.mesh = profile.shoes.model
	shoes_mesh.set_surface_override_material(0, profile.shoes.material)
	#shoes_mesh.get_active_material(0).albedo_color = profile.shoe_color_asset

func set_eyes():
	profile.eyes.material.set_transparency(1)
	eyes.set_surface_override_material(0, profile.eyes.material)
	#eyes.set_surface_override_material(0, profile.eyes.texture)
	#eyes.set_texture(0, profile.eyes.texture)

func set_mouth():
	profile.mouth.material.set_transparency(1)
	mouth.set_surface_override_material(0, profile.mouth.material)

func set_skin():
	body.set_surface_override_material(0,profile.skin.material)

func mesh_setup():
	set_hair()
	set_shirt()
	set_pants()
	set_shoes()
	set_eyes()
	set_mouth()
	set_skin()
	
	#print("Hair generated: ", profile.hair.color_title," ", profile.hair.title)
	
	#print("Shirt generated: ", profile.shirt.color_title," ", profile.shirt.title)
	
	#print("Pants generated: ", profile.pants.color_title," ",profile.pants.title)
	
	var all_meshes: Array = [hair_mesh, shirt_mesh, pants_mesh, shoes_mesh]
	
"""	for cos_mesh in all_meshes:
		if cos_mesh.mesh.surface_get_material(0) != null:
			cos_mesh.mesh.surface_get_material(0)="""
