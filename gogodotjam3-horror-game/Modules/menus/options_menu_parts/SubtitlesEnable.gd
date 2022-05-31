extends CheckBox

func _ready() -> void:
	self.pressed = Settings.subtitles_enabled

func _on_SubtitlesEnable_toggled(button_pressed: bool) -> void:
	Settings.subtitles_enabled = button_pressed
	Settings.reload_settings()
