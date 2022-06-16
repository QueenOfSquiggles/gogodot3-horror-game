extends PanelContainer

export (String) var input_action_name := ""

signal choose_key_start(controls_binding_entry)

onready var label := $HBoxContainer/Label
onready var btn_ctrl_change := $HBoxContainer/BtnCtrlChange

func _ready() -> void:
	assert(Settings.control_bindings.has(input_action_name), "ControlsBindingEntry has an invalid action name!")
	Settings.connect("refresh_settings", self, "_on_settings_changed")
	_on_settings_changed()
	label.text = input_action_name

func _on_settings_changed() -> void:
	var bind = Settings.control_bindings[input_action_name]
	if bind < 0:
		btn_ctrl_change.text = "bind: default(s)"
	else:
		btn_ctrl_change.text = "bind: %s" % OS.get_scancode_string(bind)

func _on_BtnCtrlChange_pressed() -> void:
	emit_signal("choose_key_start", self)

func _on_BtnCtrlReset_pressed() -> void:
	Settings.control_bindings[input_action_name] = -1
	Settings.reload_settings()
