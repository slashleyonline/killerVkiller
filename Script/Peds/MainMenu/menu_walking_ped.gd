extends CharacterBody3D


@onready var ped = $PedLoader/PedBase
@onready var ped_anim = $PedLoader/PedBase/AnimationTree
var walking_speed = randf_range(0.5,2)
var movement_vector = Vector3(-0.03 ,-0.02 * walking_speed,0)


func _ready():
	pass

func _physics_process(delta: float) -> void:
	self.translate(movement_vector)
	if global_position.y <= -10:
		queue_free()
	move_and_slide()
