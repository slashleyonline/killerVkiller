extends Node3D

const AMMO_MAX = 10
const MAG_SIZE = 5

@onready var anim_player = $Mesh/GunAnimation
@onready var barrel_player = $Gun/Animation/ShotSound
@onready var gun_mesh = $Gun/Animation/Mesh
@onready var barrel = $Barrel

@onready var gun_base = $Gun
var cocked = false

func get_gun_name():
	return gun_base.gun_name

func use(spawn_location: Node3D):
	if cocked && gun_base.can_fire() && !gun_base.check_anim():
		cocked = false
		gun_base.use(spawn_location)
	elif !cocked && !gun_base.check_anim():
		print("cocking!")
		if !gun_base.check_anim():
			cocked = true
			gun_base.load_weapon()
	elif cocked && !gun_base.can_fire() && !gun_base.check_anim():
		cocked = false
		gun_base.dry_fire()
	else:
		pass
		#print("the nefarious fourth option")
		#print("cocked: ", cocked)
		#print("can fire: ", gun_base.can_fire())
		#print("playing anim: ", !gun_base.check_anim())

func cock_weapon():
	gun_base.set_anim("cock")
	
func reload(inserted_ammo: int):
	gun_base.reload(inserted_ammo)

func set_ammo(setting_ammo: int):
	gun_base.set_ammo(setting_ammo)

func get_current_ammo():
	return gun_base.get_current_ammo()

func get_needed_bullets():
	return gun_base.get_needed_bullets()

func get_anim_str():
	return gun_base.get_anim_str()

func return_anim_finished():
	gun_base.return_anim_finished()

func set_anim(anim: String):
	gun_base.set_anim(anim)

func check_anim():
	return gun_base.check_anim()
