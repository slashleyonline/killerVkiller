extends RayCast3D

var bullet_hole = preload("res://prefabs/Decal/bullet_hole.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	"""if self.is_colliding():
		print(self.get_collider().name)
	else:
		print("no collision detected.")"""


func fire(damage: float):
	print("firing!")
	self.enabled = true
	if self.is_colliding():
		var col_point = self.get_collision_point() 
		var normal = self.get_collision_normal()
		var target = self.get_collider()
		
		if target != null:
			var name = target.name
			print("hit ", name)
			
			
		self.enabled = false
