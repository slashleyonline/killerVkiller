extends Node3D

var is_active:
	set(input):
		is_active = input
		set_key_color()
@export var color: Color = Color.BLUE_VIOLET
@export var color_str: String = "DEBUG!" 
var is_used: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_key_color():
	var mesh = $key/Cube
	var material = mesh.get_active_material(0)
	
	material = material.duplicate()
	mesh.set_surface_override_material(0, material)

	
	material.albedo_color = color
	#print("color set to: ", color_str)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
