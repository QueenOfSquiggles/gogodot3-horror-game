extends Node

"""
Refer to :

https://github.com/Calinou/godot-sponza/blob/master/scripts/settings_gui.gd#L130

for more info on making graphics settings.

"""

signal refresh_settings

const SAVE_PATH := "user://settings.json"

var fullscreen := false
var use_retro_filter := true
var viewport_msaa := Viewport.MSAA_DISABLED
var subtitles_enabled := false

var world_environment := {
	"glow_enabled" : true,
	"ssao_enabled" : false,
	"ss_reflections_enabled" : false,
}

var audio_bus := {
	"Master" : {
		"muted" : false,
		"volume" : 0
	},
	"SoundEffects" : {
		"muted" : false,
		"volume" : 0
	},
	"VoiceLines" : {
		"muted" : false,
		"volume" : 0
	},
	"Music" : {
		"muted" : false,
		"volume" : 0
	},
	"Misc" : {
		"muted" : false,
		"volume" : 0
	}
}

func reload_settings() -> void:
	emit_signal("refresh_settings")
	get_viewport().msaa = viewport_msaa
	OS.window_fullscreen = fullscreen
	Subtitles.subtitles_enabled = subtitles_enabled
	if not subtitles_enabled:
		# extra precaution to remove accidental subtitles
		Subtitles.call_deferred("clear_subtitles")
	for bus in audio_bus:
		# handle audio server
		var idx := AudioServer.get_bus_index(bus)
		var data = audio_bus[bus]
		AudioServer.set_bus_volume_db(idx, data.volume)
		AudioServer.set_bus_mute(idx, data.muted)
	_save_settings() # when changed, save the settings to disk


func _ready() -> void:
	_load_settings()

func _save_settings() -> void:
	var data_dict := {
		# make sure the key matches the variable name exactly!
		"fullscreen" : fullscreen,
		"use_retro_filter" : use_retro_filter,
		"viewport_msaa" : viewport_msaa,
		"subtitles_enabled" : subtitles_enabled,
		"world_environment" : world_environment,
		"audio_bus" : audio_bus
	}
	var err := SaveData.save_generic(SAVE_PATH,data_dict) 
	if err != OK:
		push_warning("Error #%s on saving game settings. Please invenstigate" % str(err))

func _load_settings() -> void:
	var data := SaveData.load_generic(SAVE_PATH)
	if not data.empty():
		for key in data.keys():
			self.set_indexed(key, data[key])
		reload_settings() # reload on settings changed
	else:
		# use a warning because for users this should only happen once.
		_save_settings()
		push_warning("No data found for game settings. If this isn't the first time running, there may be an error")


