extends Node3D

@export var anim: AnimationPlayer

func set_anim(anim_str: String):
	if anim != null :
		anim.play(anim_str)
	

func wait():
	await anim.animation_finished

func get_anim():
	if anim != null and anim.is_playing():
		return anim.current_animation
	return "NULL"

func check_anim():
	if anim != null:
		return anim.is_playing()
	print("no anim player assigned! returning false")
	return false
