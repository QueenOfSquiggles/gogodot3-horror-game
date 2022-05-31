extends Node
class_name GraphicsPresets

const ID_PRESET_LOW := 0
const ID_PRESET_MEDIUM := 0
const ID_PRESET_HIGH := 0

const PRESET_LOW := {
	"viewport_msaa" : Viewport.MSAA_DISABLED,
	"world_environment" : {
		"glow_enabled" : false,
		"ssao_enabled" : false,
		"ss_reflections_enabled" : false,
	}
}
const PRESET_MEDIUM := {
	"viewport_msaa" : Viewport.MSAA_2X,
	"world_environment" : {
		"glow_enabled" : true,
		"ssao_enabled" : true,
		"ss_reflections_enabled" : false,
	}
}
const PRESET_HIGH := {
	"viewport_msaa" : Viewport.MSAA_8X,
	"world_environment" : {
		"glow_enabled" : true,
		"ssao_enabled" : true,
		"ss_reflections_enabled" : true,
	}
}

static func apply_preset(preset : Dictionary) -> void:
	for key in preset.keys():
		Settings.set_indexed(key, preset[key])
	Settings.reload_settings()

static func apply_preset_id(id : int) -> void:
	match(id):
		ID_PRESET_LOW:
			apply_preset(PRESET_LOW)
		ID_PRESET_MEDIUM:
			apply_preset(PRESET_MEDIUM)
		ID_PRESET_HIGH:
			apply_preset(PRESET_HIGH)
	
