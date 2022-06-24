extends HBoxContainer

onready var skip_splash := $CheckSkipSplash

func _ready() -> void:
	skip_splash.pressed = Settings.skip_splash_screens
	
func _on_CheckSkipSplash_toggled(button_pressed: bool) -> void:
	Settings.skip_splash_screens = button_pressed
	Settings.reload_settings()
	print("SkipSplashScreens : %s" % str(Settings.skip_splash_screens))
