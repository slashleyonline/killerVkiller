extends Node

class_name Facial

var texture: CompressedTexture2D:
	get: return texture
	set(new_tex): 
		texture = new_tex
		if material.albedo_texture == null:
			material.albedo_texture = texture.duplicate()
var material: StandardMaterial3D = StandardMaterial3D.new():
	get: return material
	set(new_material): 
		material = new_material
var title: String:
	get: return title
	set(new_title): title = new_title
