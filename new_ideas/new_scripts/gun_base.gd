extends Node3D
class_name GunBase

@export var gun_name: String
@onready var fire_logic = $Fire
@onready var ammo_logic = $Ammo_Logic
@onready var animation = $Animation

func use(bullet_spawn: Node3D):
	#print("used weapon!")
	if (!check_anim()):
		if ammo_logic.can_fire():
			fire_logic.fire(bullet_spawn)
			ammo_logic.on_fire()
			set_anim("fire")
			animation.wait()
	"""
	When the player uses a firearm, they will either be pulling
	the trigger or cocking/racking the firearm. this function
	is for determining that. if there is ammo according to the ammo
	logic, and if the gun is loaded, it can fire.
	"""

func dry_fire():
	if (!check_anim()):
		set_anim("dry_fire")
		animation.wait()

func can_fire():
	return ammo_logic.can_fire()

func load_weapon():
	if (!check_anim()):
		set_anim("cock")
		animation.wait()

func reload(inserted_ammo: int):
	if inserted_ammo != 0:
		if (!check_anim()):
			ammo_logic.reload(inserted_ammo)
			set_anim("reload")

func set_anim(anim: String):
	animation.set_anim(anim)

func check_anim():
	return animation.check_anim()

func get_anim_str():
	return animation.get_anim()

func set_ammo(ammo_to_set: int):
	ammo_logic.set_bullets(ammo_to_set)

func get_current_ammo():
	return ammo_logic.bullets

func get_needed_bullets():
	return ammo_logic.get_needed_bullets()

func return_anim_finished():
	await animation.anim.animation_finished
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_anim("activate")
