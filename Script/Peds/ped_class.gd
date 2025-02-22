extends Node
class_name Pedestrian

var ped_name: String
var is_player: bool
var alive: bool

var skin: SkinType:
	get: return skin
	set(new_skin):
		skin = new_skin
var eyes: Facial:
	get: return eyes
	set(new_eyes):
		eyes = new_eyes
var mouth: Facial:
	get: return mouth
	set(new_mouth):
		mouth = new_mouth
var hair: Cosmetic:
	get: return hair
	set(new_hair):
		hair = new_hair
var shirt: Cosmetic:
	get: return shirt
	set(new_shirt):
		shirt = new_shirt
var pants: Cosmetic:
	get: return pants
	set(new_pants):
		pants = new_pants
var shoes: Cosmetic:
	get: return shoes
	set(new_shoes):
		shoes = new_shoes
