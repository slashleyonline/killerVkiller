extends Node3D

@onready var skeleton = $PedBase/Armature/Skeleton3D
@onready var body: MeshInstance3D = $PedBase/Armature/Skeleton3D/Body
@onready var hair: MeshInstance3D = $PedBase/Armature/Skeleton3D/Hair
@onready var eyes: MeshInstance3D = $PedBase/Armature/Skeleton3D/Eyes
@onready var mouth: MeshInstance3D = $PedBase/Armature/Skeleton3D/Mouth
@onready var shirt: MeshInstance3D = $PedBase/Armature/Skeleton3D/Shirt
@onready var pants: MeshInstance3D = $PedBase/Armature/Skeleton3D/Pants
@onready var shoes: MeshInstance3D = $PedBase/Armature/Skeleton3D/Shoes

@onready var skin_colors =  [Color.WHEAT, Color.BEIGE, Color.SANDY_BROWN,
Color.ANTIQUE_WHITE, Color.PERU, Color.LIGHT_YELLOW, Color.LIGHT_CORAL]

@onready var clothes_colors = [Color.CRIMSON, Color.NAVY_BLUE, 
Color.DARK_OLIVE_GREEN, Color.BLACK, Color.BLUE_VIOLET, Color.PINK, 
Color.DARK_ORANGE]

@onready var hair_colors = [Color.SADDLE_BROWN, Color. BLACK, Color.GRAY, 
Color.WEB_MAROON, Color.LIGHT_YELLOW]

@onready var shoe_colors = [Color.BLACK, Color.WHITE, Color.BROWN, Color.ORANGE_RED, Color.SIENNA]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_ped()

func generate_ped() -> void:
	body.get_active_material(0).albedo_color = skin_colors[randi() % skin_colors.size()]
	eyes.get_active_material(0).set_texture(0, random_face_texture("Eyes"))
	mouth.get_active_material(0).set_texture(0, random_face_texture("Mouth"))
	
	hair.mesh = random_mesh("Hair")
	
	shirt.mesh = random_mesh("Shirts")
	
	pants.mesh = random_mesh("Pants")
	
	shoes.mesh = random_mesh("Shoes")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func random_mesh(mesh_type: String) -> Mesh:
	var mesh_path: String = "res://Models/Player/Cosmetic/%s"
	var final_path = mesh_path % mesh_type
	var res_files = DirAccess.get_files_at(final_path)
	var random_file = res_files[randi() % res_files.size()]
	var load_mesh = load(str(final_path,"/",random_file))
	
	if random_file != "Bald.tres":
		load_mesh = random_color(load_mesh, mesh_type)
	
	return load_mesh

func random_face_texture(tex_type: String) -> CompressedTexture2D:
	var load_tex
	var tex_path: String = "res://textures/Face/%s"
	var final_path = tex_path % tex_type
	
	var res_files = DirAccess.get_files_at(final_path)
	var random_file = res_files[randi() % res_files.size()]
	if random_file.get_extension() == "png":
		load_tex = load(str(final_path,"/",random_file))
		return load_tex
	else:
		return random_face_texture(tex_type)

func random_color(current_mesh, mesh_type: String) -> Mesh:
	var current_material = current_mesh.surface_get_material(0)
	if mesh_type == "Hair":
		current_material.albedo_color = hair_colors[randi() % hair_colors.size()]
	elif mesh_type == "Shirt":
		print("Searching clothes color")
		current_material.albedo_color = clothes_colors[randi() % clothes_colors.size()]
	elif mesh_type == "Pants":
		current_material.albedo_color = clothes_colors[randi() % clothes_colors.size()]
	elif mesh_type == "Shoes":
		current_material.albedo_color = shoe_colors[randi() % shoe_colors.size()]

	current_mesh.surface_set_material(0, current_material)
	
	return current_mesh

func _on_regen_button_pressed() -> void:
	generate_ped()
