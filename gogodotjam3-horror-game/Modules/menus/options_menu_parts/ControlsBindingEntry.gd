extends PanelContainer

export (String) var input_action_name := ""

signal choose_key_start(controls_binding_entry)

onready var label := $HBoxContainer/Label
onready var btn_ctrl_change := $HBoxContainer/BtnCtrlChange

func _ready() -> void:
	assert(Settings.control_bindings.has(input_action_name), "ControlsBindingEntry has an invalid action name!")
	Settings.connect("refresh_settings", self, "_on_settings_changed")
	_on_settings_changed()
	label.text = "options.controls.action." + input_action_name

func _on_settings_changed() -> void:
	var bind_info = Settings.control_bindings[input_action_name]
	var bind :int = bind_info.bind
	var bind_type :int = bind_info.type
	btn_ctrl_change.text = parse_input_binding(bind, bind_type)

func parse_input_binding(binding : int, bind_type : int) -> String:
	match(bind_type):
		Settings.InputTypes.NULL:
			# no custom bindings set
			return "options.controls.bind.default"
		
		Settings.InputTypes.KEYBOARD:
			# parse keyboard scancode into a readable string
			return OS.get_scancode_string(binding)
		Settings.InputTypes.GAMEPAD_BUTTON:
			return Input.get_joy_button_string(binding)
		Settings.InputTypes.GAMEPAD_AXIS:
			return Input.get_joy_axis_string(binding)
		_:
			# fix for any that can't be parsed to look pretty
			# this just shows the input type and the binding of said input type
			return "[%s]-{%s}" % [Settings.InputTypes.keys()[bind_type], str(binding)]

func _on_BtnCtrlChange_pressed() -> void:
	emit_signal("choose_key_start", self)

func _on_BtnCtrlReset_pressed() -> void:
	Settings.control_bindings[input_action_name] = {
		"bind" : -1,
		"type" : -1
	}
	Settings.reload_settings()
