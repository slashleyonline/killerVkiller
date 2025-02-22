extends Node3D

@export var max_bullets: int
var bullets: int = 6:
	set(input):
		bullets = input
		print("revolver bullets set to ", bullets)
		if bullets > max_bullets:
			print("ERROR! BULLET COUNT EXCEEDED MAX BULLETS!!!!!")
var can_reload: bool

func on_fire():
	bullets -= 1

func reload(loading_bullets: int):
	##takes the amount of bullets sent by the player and loads
	##them into the gun.
	#print("loading bullets ", loading_bullets)
	if loading_bullets > 6:
		print("loading bullets = 6")
		loading_bullets = 6
	
	var spent_bullets = max_bullets - bullets
	var bullets_to_load = (max_bullets - (abs(loading_bullets - spent_bullets)))
	
	##print("loading bullets ", loading_bullets)
	##print("spent_bullets ", spent_bullets)
	##print("bullets to load: ", bullets_to_load)
	
	if max_bullets != 0 and bullets < max_bullets and \
	loading_bullets >= bullets_to_load:
		bullets += spent_bullets
	
	elif max_bullets != 0 and bullets < max_bullets and \
	loading_bullets < bullets_to_load:
		bullets += loading_bullets
	
	print("loaded gun with ", bullets_to_load, " bullets")

func set_bullets(bullets_to_set: int):
	bullets = bullets_to_set

func get_bullets():
	return bullets

func get_needed_bullets():
	print("returning ", max_bullets, " - ", bullets)
	return max_bullets - bullets

func can_fire():
	if bullets > 0:
		return true
	return false
