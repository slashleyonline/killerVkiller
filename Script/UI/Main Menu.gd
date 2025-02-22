extends Node

@onready var start_menu = $StartMenu
@onready var game_settings = $GameSettings
@onready var options_menu = $OptionsMenu

@onready var audio_test = $OptionsMenu/VBoxContainer/Volume/AudioTest

@onready var game_volume_label = $OptionsMenu/VBoxContainer/Volume/Label
@onready var game_volume_slider = $"OptionsMenu/VBoxContainer/Volume/Game Volume"
@onready var resolution_button = $OptionsMenu/VBoxContainer/Resolution/Resolution
@onready var map_selection_menu = $MapSelection

@onready var visibility_timer = $GameSettings/VBoxContainer/Warning/VisibilityTimer
@onready var warning_panel = $GameSettings/VBoxContainer/Warning

@onready var round_slider = $GameSettings/VBoxContainer/RoundSetting/VBoxContainer/HSlider

const RESOLUTION_DICTIONARY : Dictionary ={
	"640 x 480" : Vector2(640, 480),
	"800 x 600" : Vector2(800, 600),
	"1024 x 768" : Vector2(1024, 768),
	"1152 x 864" : Vector2(1152, 864),
	"1176 x 664" : Vector2(1176, 664),
	"1280 x 720" : Vector2(1280, 720),
	"1280 x 800" : Vector2(1280, 800),
	"1360 x 760" : Vector2(1360, 760),
	"1366 x 760" : Vector2(1366, 768),
	"1600 x 900" : Vector2(1600, 900),
	"1920 x 1080" : Vector2(1920, 1080)
	}

func _ready():
	add_resolution_tiems()
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[3])
	resolution_button.selected = 3

func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("ui_cancel"):
			if game_settings.visible == true:
				game_settings.visible = false
				start_menu.visible = true
			elif options_menu.visible == true:
				options_menu.visible = false
				start_menu.visible = true
			elif map_selection_menu.visible == true:
				map_selection_menu.visible = false
				game_settings.visible = true

func _on_play_pressed():
	start_menu.visible = false
	game_settings.visible = true

func _on_options_pressed():
	start_menu.visible = false
	options_menu.visible = true


func _on_quit_pressed():
	get_tree().quit()


func _on_h_slider_value_changed(value):
	var round_label = $GameSettings/VBoxContainer/RoundSetting/VBoxContainer/Label
	round_label.text = "Score Limit: %s" %round_slider.value

func _on_game_volume_value_changed(value):
	game_volume_label.text = "Volume: %s" % value
	var volume_value = -50
	if value != 0:
		AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0, volume_value + value/2)
	elif value == 0:
		AudioServer.set_bus_mute(0, true)

func _on_fullscreen_check_box_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(3)
	else:
		DisplayServer.window_set_mode(0)

func _on_borderless_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_flag(1, true)
	else:
		DisplayServer.window_set_flag(1, false)

func _on_vsync_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_vsync_mode(1)
	else:
		DisplayServer.window_set_vsync_mode(0)


func _on_options_back_pressed():
	options_menu.visible = false
	start_menu.visible = true


func _on_game_volume_drag_ended(value_changed):
	if !audio_test.is_playing():
		audio_test.play()

func add_resolution_tiems():
	for item in RESOLUTION_DICTIONARY:
		resolution_button.add_item(item)


func _on_resolution_item_selected(index):
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])

func _on_select_maps_pressed():
	pass
	#game_settings.visible = false
	#map_selection_menu.visible = true


func _on_back_to_game_settings_pressed():
	map_selection_menu.visible = false
	game_settings.visible = true
