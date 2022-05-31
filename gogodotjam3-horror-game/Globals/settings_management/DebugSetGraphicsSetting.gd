extends Node

enum Preset {
	LOW, MEDIUM, HIGH
}

export (Preset) var graphics_preset := Preset.MEDIUM

func _ready() -> void:
	var preset := GraphicsPresets.PRESET_LOW
	if graphics_preset == Preset.MEDIUM:
		preset = GraphicsPresets.PRESET_MEDIUM
	if graphics_preset == Preset.HIGH:
		preset = GraphicsPresets.PRESET_HIGH
	GraphicsPresets.apply_preset(preset)
