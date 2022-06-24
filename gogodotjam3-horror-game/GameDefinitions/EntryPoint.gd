extends Node

export (String) var splash_path := "res://Modules/splash_screens/SplashVideoSequence.tscn"
export (String) var main_menu_path := "res://Modules/menus/MainMenu.tscn"

func _ready() -> void:
	Settings.reload_settings() # double-ensure settings are loaded
	if Settings.skip_splash_screens:
		SceneManagement.load_scene(main_menu_path)
	else:
		SceneManagement.load_scene(splash_path)
