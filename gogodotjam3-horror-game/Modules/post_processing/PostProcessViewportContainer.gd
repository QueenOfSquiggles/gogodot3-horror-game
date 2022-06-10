extends ViewportContainer

export (Material) var dither_material : Material


func _ready() -> void:
	var _clr := Settings.connect("refresh_settings", self, "_manage_material")
	_manage_material()

func _manage_material() -> void:
	self.material = dither_material if Settings.use_retro_filter else null
