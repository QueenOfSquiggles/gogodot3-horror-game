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

var sensitivity := {
	# sensitivity for mouse and gamepad controls
	"mouse" : 1.0,
	"gamepad" : 1.0
}

# this makes the sensitivity more meaningful for the user.
# 0.1 sensitivity means 50 pixels per second, which is abysmally slow for a look input 
const GLOBAL_GAMEPAD_LOOK_FACTOR := 500.0

var look_inversions := {
	"mouse" : [false, false],
	"gamepad" : [false, true] # gamepad is invert-y by default. Just like I like it ;D
}

enum InputTypes {
	# this should cover all valid types?
	KEYBOARD,
	MOUSE_BUTTON,
	GAMEPAD_BUTTON,
	GAMEPAD_AXIS,
	NULL = -1, # used for defaults, basically no custom binding
}

var control_bindings := {
	"ui_left" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"ui_right" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"ui_up" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"ui_down" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"ui_accept" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"ui_cancel" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"move_forwards" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"move_backwards" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"move_left" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"move_right" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"jump" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"use_item" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"interact" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"sprint" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"toggle_rotate_item" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"toggle_flashlight" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"pause" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"joy_look_up" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"joy_look_down" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"joy_look_left" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
	"joy_look_right" : {
		"bind" : -1,
		"type" : InputTypes.NULL,
	},
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

func _set_input_action(action_name : String, bind_info : Dictionary) -> void:
	# clear existing bindings
	var input_events := InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)

	# extract dict info
	var bind_code :int = bind_info.bind
	var bind_type :int = bind_info.type

	# bind events based on bind_type
	var bind_event : InputEvent
	match(bind_type):
		InputTypes.KEYBOARD: # load keyboard bindings
			bind_event = InputEventKey.new()
			(bind_event as InputEventKey).scancode = bind_code
		
		InputTypes.MOUSE_BUTTON:
			bind_event = InputEventMouseButton.new()
			(bind_event as InputEventMouseButton).button_index = bind_code

		InputTypes.GAMEPAD_BUTTON:
			bind_event = InputEventJoypadButton.new()
			(bind_event as InputEventJoypadButton).button_index = bind_code
		
		InputTypes.GAMEPAD_AXIS:
			bind_event = InputEventJoypadMotion.new()
			(bind_event as InputEventJoypadMotion).axis = bind_code
		
		_: # default case -> load default bindings
			var events :Array = default_control_bindings_cache[action_name]
			for e in events:
				InputMap.action_add_event(action_name, e)

	if bind_event:
		# if a binding was loaded, assign it to the action
		InputMap.action_add_event(action_name, bind_event)


func _save_settings() -> void:
	var data_dict := {
		# make sure the key matches the variable name exactly!
		"fullscreen" : fullscreen,
		"use_retro_filter" : use_retro_filter,
		"viewport_msaa" : viewport_msaa,
		"subtitles_enabled" : subtitles_enabled,
		"world_environment" : world_environment,
		"audio_bus" : audio_bus,
		"control_bindings" : control_bindings,
		"sensitivity" : sensitivity,
		"look_inversions" : look_inversions
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


