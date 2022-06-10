extends WorldEnvironment

func _ready() -> void:
	var _clear = Settings.connect("refresh_settings", self, "apply_settings")
	call_deferred("apply_settings")

func apply_settings() -> void:
	var data := Settings.world_environment
	for key in data.keys():
		self.environment.set_indexed(key, data[key])
