extends Button

export (String) var URI := ""

func _ready() -> void:
	var _clear = self.connect("pressed", self, "on_social_pressed")

func on_social_pressed() -> void:
	var _clear = OS.shell_open(URI)
