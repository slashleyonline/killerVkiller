extends Node3D

@export var color: String
@onready var anim_player = $AnimationPlayer
@onready var lock_mesh = $lock
var opened: bool:
	set(input):
		opened = input
		if opened == true:
			lock_mesh.visible = false
@onready var item_spawn = $ItemLocation
@onready var body = $StaticBody3D

"""
(need key item with correct color)
(start testing with one color just to get it open.)
set color - set a color that corresponds with the correct key.
END THE SESSION IF THERE IS NO CORRESPONDING KEY
set item - randomizes item 
open- needs the proper key.
"""

func attempt_unlock(key_color: String):
	if key_color == color:
		unlock()

func unlock():
	
	#print("unlocked box!")
	if opened != true:
		opened = true
		body.set_collision_layer_value(3, false)
		anim_player.play("Open")

func set_item():
	var pickups = [load("res://prefabs/Pickups/weapons/knife_pickup.tscn"),
	load("res://prefabs/Pickups/weapons/revolver_pickup.tscn")]
	var pickup_to_spawn = pickups[randi() % pickups.size()]
	pickup_to_spawn = pickup_to_spawn.instantiate()
	pickup_to_spawn.freeze = true
	item_spawn.add_child(pickup_to_spawn)
	#print("pickup to spawn is: ", pickup_to_spawn)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_item()
	pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
