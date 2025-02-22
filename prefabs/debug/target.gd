extends StaticBody3D

@export var health = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func take_dmg(dmg: float, force: Vector3):
	health -= dmg
	print("Target health: ", health)
	if health <= 0:
		queue_free()
