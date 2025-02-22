extends Node

class_name Cosmetic

var title: String = "Unnamed"
var model: ArrayMesh:
	get: return model
	set(new_model): 
		model = new_model
var color_title: String
var material: StandardMaterial3D = StandardMaterial3D.new():
	get: return material
	set(new_material): 
		material = new_material
		if model.surface_get_material(0) != null:
			model.surface_set_material(0, material)
