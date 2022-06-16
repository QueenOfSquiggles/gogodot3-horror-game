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


var control_bindings := {
	"ui_left" : -1,
	"ui_right" : -1,
	"ui_up" : -1,
	"ui_down" : -1,
	"ui_accept" : -1,
	"ui_cancel" : -1,
	"move_forwards" : -1,
	"move_backwards" : -1,
	"move_left" : -1,
	"move_right" : -1,
	"jump" : -1,
	"use_item" : -1,
	"interact" : -1,
	"toggle_rotate_item" : -1,
	"toggle_flashlight" : -1,
	"pause" : -1
}

var default_control_bindings_cache := {
	# This holds the default events lists (deep copy) for each action. This lets us reset to the 'true" default without requiring a restart of the application! Does take up storage space, but it's worth it for the benefit I think
}

func _ready() -> void:
	for action in control_bindings.keys():
		var events := InputMap.get_action_list(action)
		default_control_bindings_cache[action] = events.duplicate(true)
	_load_settings()

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
	for action in control_bindings:
		_set_input_action(action, control_bindings[action])
	_save_settings() # when changed, save the settings to disk

func _set_input_action(action_name : String, key_code : int) -> void:
	# clear existing bindings
	var input_events := InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)

	if key_code < 0:
		# load default binding(s)
		# technically the first load of inputs will clear all inputs and then reset them to defaults. Which is kinda weird
		var events :Array = default_control_bindings_cache[action_name]
		for e in events:
			InputMap.action_add_event(action_name, e)
		pass
	else:
		# load custom binding (only supports keyboard input for now)
		var new_event := InputEventKey.new()
		new_event.scancode = key_code
		InputMap.action_add_event(action_name, new_event)


func _save_settings() -> void:
	var data_dict := {
		# make sure the key matches the variable name exactly!
		"fullscreen" : fullscreen,
		"use_retro_filter" : use_retro_filter,
		"viewport_msaa" : viewport_msaa,
		"subtitles_enabled" : subtitles_enabled,
		"world_environment" : world_environment,
		"audio_bus" : audio_bus,
		"control_bindings" : control_bindings
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


