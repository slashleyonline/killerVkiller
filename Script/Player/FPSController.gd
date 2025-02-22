extends CharacterBody3D

const SPEED = 20.0
const JUMP_VELOCITY = 10
const SENSITIVITY = 0.005

var revolver_bullets = 6
var shotgun_bullets = 10

signal send_dir(x: float, y: float)

signal send_item_for_anim(title: String)

signal ped_gun_anim(weapon: String)

signal dropped_item

#var bullet_scene = preload("res://prefabs/Weapon/Bullets/revolver_bullet.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var cam = $Head/Camera3D
@onready var pause_screen = $CanvasLayer/Pause
@onready var inventory = $"Head/Camera3D/ItemHandler/Inventory"
@onready var collider = $CollisionShape3D
@onready var ped_controller = $Pedestrian


@onready var cinema_cam = $CinematicCam
@onready var interact_ray = $Head/Camera3D/InteractRaycast
@onready var spawn_location = $Head/Camera3D/spawnlocation

#When game manager class is created this should be moved.
var paused: bool = false

#accuracy penalty
var acc_pen: float

#zooming bool for ADS
var is_zoomed: bool = false
var zoom_fov: float = 75

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ped_controller.visible = false

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		cam.rotate_x(-event.relative.y * SENSITIVITY)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-85), deg_to_rad(85))

func _physics_process(delta):
	#items_arr = item_holder.get_children()
	# Add the gravity.
	
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("primary fire"):
		inventory.use_item()
	
	if Input.is_action_just_pressed("fullscreen"):
		toggle_fullscreen()
	

	#DEBUG: TEMPORARY CAMERA MODE FOR VIEWING ANIMS
	if Input.is_action_just_pressed("switch_cams"):
		if cinema_cam.current == true:
			cinema_cam.current = false
			inventory.ui_set_visible(true)
			ped_controller.visible = false
		else:
			cinema_cam.current = true
			inventory.ui_set_visible(false)
			ped_controller.visible = true
	"""
	if Input.is_action_just_pressed("reload"):
		inventory.reload()
	
	"""
	if inventory.get_can_switch() == true:
		if Input.is_action_just_pressed("next_item") :
			inventory.select_current_item(1)
		if Input.is_action_just_pressed("prev_item") :
			inventory.select_current_item(-1)
	"""
	if current_item != null && current_item.has_method("set_key_color"):
		if current_item.is_used == true:
			var item_str = "%s Key" % current_item.color_str
			#print(item_str)
			remove_item(inventory.search_by_string(item_str))
	"""
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var x_dir = float(input_dir.x)
	var y_dir = float(input_dir.y)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if is_on_floor():
			emit_signal("send_dir", lerp(x_dir, 0.0, delta * 10), lerp(y_dir, 0.0, delta * 10))
	else:
		emit_signal("send_dir", 0, 0)
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	acc_pen = abs(x_dir) + abs(y_dir) + randf_range(0.1,0.2)
	if !is_zoomed:
		pass
		#acc_pen = acc_pen + randf_range(0.1,0.2)
	#print("Accuracy penalty at: ", acc_pen)
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("pause"):
		pause()
	
	if Input.is_action_just_pressed("drop_item"):
		inventory.drop_current_item()


	
	if Input.is_action_just_pressed("zoom"):
		if !is_zoomed:
			is_zoomed = true
			cam.fov = 25
			print("ZOOM!")
		else:
			is_zoomed = false
			cam.fov =75

	move_and_slide()

func toggle_fullscreen():
	print(DisplayServer.window_get_mode(0))
	if DisplayServer.window_get_mode(0) == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func pause():
	if paused == false:
		paused = true
		pause_screen.visible = true
		get_tree().paused = true
		#print("paused!")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		paused = false
		pause_screen.visible = false
		get_tree().paused = false
		#print("unpaused!")
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_button_pressed() -> void:
	pause()

func _on_ped_loader_gen_complete() -> void:
	"""THIS SYSTEM MUST BE REVISED UPON MULTIPLAYER IMPLEMENTATION"""
	var ped_base = $PedLoader/PedBase
	ped_base.visible = false

func take_dmg(dmg: float, force: Vector3):
	#print("took ", dmg, " damage")
	ped_controller.health -= dmg
