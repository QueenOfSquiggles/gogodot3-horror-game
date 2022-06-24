extends HBoxContainer

onready var check_fps := $CheckDebugFPS

func _ready() -> void:
	check_fps.pressed = Settings.show_debug

func _on_CheckDebugFPS_toggled(button_pressed: bool) -> void:
	Settings.show_debug = button_pressed
	Settings.reload_settings()
