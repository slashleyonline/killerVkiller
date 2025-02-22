extends Node3D

# NOTE: Make sure min bounce distance is greater than min raycast distance
const MIN_RAYCAST_DISTANCE := 0.05

var bullet_hole = preload("res://prefabs/Decal/bullet_hole.tscn")

@onready var _ray = $RayCast3D
var velocity
@export var speed = 250
@export var dmg = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = self.transform.basis.z * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var distance = velocity.length() * delta
	self.transform.origin -= velocity * delta

	# Change the ray start position to the bullets's previous position
	# NOTE: The ray is backwards, so if it is hitting multiple targets, we
	# get the target closest to the bullet start position.
	# Also make the ray at least the min length
	if distance > MIN_RAYCAST_DISTANCE:
		_ray.target_position.z = -distance
		_ray.transform.origin.z = distance
	else:
		_ray.target_position.z = -MIN_RAYCAST_DISTANCE
		_ray.transform.origin.z = MIN_RAYCAST_DISTANCE

	# Check if hit something
	_ray.force_raycast_update()
	if _ray.is_colliding():
		var target = _ray.get_collider()
		var col_point = _ray.get_collision_point() 
		var normal = _ray.get_collision_normal()
		
		#print("Bullet hit %s" % [target.name])
		#print(col_point)
		
		if (target.is_in_group("target") or target.is_in_group("Pedestrian")) and target.has_method("take_dmg"):
			#print("target hit!")
			target.take_dmg(50, col_point.direction_to(target.position))
		
		if (!target.is_in_group("Pedestrian")):
			var new_hole = bullet_hole.instantiate()
			target.add_child(new_hole)
			new_hole.global_position = col_point
			if normal != Vector3.UP:
				new_hole.look_at(col_point+Vector3.UP, normal)
				new_hole.rotate(normal, randf_range(0, 2 * PI))
		#new_hole.look_at(col_point + normal, Vector3.UP)
		#new_hole.look_at(col_point + normal, Vector3.RIGHT)
		
		queue_free()
