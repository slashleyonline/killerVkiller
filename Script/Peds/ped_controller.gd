extends Node3D

@export var is_player: bool = false

@onready var pedbase = $PedLoader/PedBase
var ped_anim
var state_machine
var move_vect: Vector2
@onready var item_meshes = $PedLoader/PedBase/Armature/Skeleton3D/BoneAttachment3D/Item
@onready var skel = $PedLoader/PedBase/Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var death_noise = $PedLoader/PedBase/DeathNoise
var revolver
var knife
var current_item
var current_weapon
var fire_anim_pause: bool =false 

var health: int = 100:
	set(amount):
		if amount <= 0:
			health = 0
		else:
			health = amount

func take_dmg(dmg: float, force: Vector3):
	#print(self.name, " took ", dmg, " damage")
	health -= dmg
	if (health == 0):
		death(force)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_ped_loader_gen_complete() -> void:
	#THIS SYSTEM MUST BE REVISED UPON MULTIPLAYER IMPLEMENTATION
	if is_player:
		var ped_base = $PedLoader/PedBase
		ped_anim = $PedLoader/PedBase/AnimationTree
		revolver = $PedLoader/PedBase/Armature/Skeleton3D/BoneAttachment3D/Item/Revolver
		knife = $PedLoader/PedBase/Armature/Skeleton3D/BoneAttachment3D/Item/Knife
		state_machine = ped_anim["parameters/ArmsSM/playback"]
		ped_anim.connect("animation_finished", on_anim_finished)
		#ped_base.visible = false

func on_anim_finished(anim_name: String):
	if anim_name == "FireOneHanded" or "Reloading":
		fire_anim_pause = false

func death(force: Vector3):
	death_noise.playing = true
	var hip = skel.get_node("Physical Bone Hip_R")
	skel.physical_bones_start_simulation()
	hip.linear_velocity = force * 80


func _on_player_send_dir(x: float, y: float) -> void:
	move_vect.x = x
	move_vect.y = -y
	ped_anim.set("parameters/dir/blend_position", move_vect)
	
	#print("dir x: ", x, " dir y: ", y)
	
	if current_item == "Unarmed" and ((x != 0) or (y != 0)):
		state_machine.travel("WalkArms")
	elif current_item == "Unarmed" and ((x== 0) and (y == 0)):
		state_machine.travel("IdleArms")
	elif (current_item == "Revolver") or (current_item == "Knife"):
		if !fire_anim_pause:
			if ((x != 0) or (y != 0)):
				state_machine.travel("HoldingItemWalk")
			else:
				state_machine.travel("HoldingItem")
	


func _on_ped_send_item_for_anim(title: String) -> void:
	if current_weapon != null:
		current_weapon.visible = false
	current_item = title
	if title == "Unarmed":
		print("no weapon!")
		current_weapon = null
	elif title == "Revolver":
		revolver.visible = true
		current_weapon = revolver
	elif title == "Knife":
		knife.visible = true
		current_weapon = knife


func _on_ped_ped_gun_anim(weapon: String) -> void:
	if weapon == "Revolver":
		fire_anim_pause = true
		if state_machine.get_current_node() == "FireOneHanded":
			state_machine.start("FireOneHanded", true)
		else:
			state_machine.travel("FireOneHanded")
	if weapon == "OneHandedReload":
		print("Reloading!")
		fire_anim_pause = true
		state_machine.start("Reloading", true)
