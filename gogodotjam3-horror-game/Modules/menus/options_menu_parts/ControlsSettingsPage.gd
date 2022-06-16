extends MarginContainer

onready var bindings_root := $"%ControlsBindingsRoot"
onready var select_pane := $SelectPane

const binding_scene := preload("res://Modules/menus/options_menu_parts/ControlsBindingEntry.tscn")

func _ready() -> void:
	for action in Settings.control_bindings.keys():
		_create_binding_entry(action)
	select_pane.visible = false

func _create_binding_entry(action : String) -> void:
	var slot := binding_scene.instance()
	slot.input_action_name = action
	bindings_root.add_child(slot)
	slot.connect("choose_key_start", self, "select_key", [], CONNECT_DEFERRED)

func select_key(slot) -> void:
	print("Key selecting! %s" % slot.input_action_name)
	select_pane.open()
	var key_code :int = yield(select_pane, "key_selected")
	yield(VisualServer, "frame_post_draw")
	Settings.control_bindings[slot.input_action_name] = key_code
	Settings.reload_settings()


func _on_BtnResetAll_pressed() -> void:
	for action in Settings.control_bindings.keys():
		Settings.control_bindings[action] = -1
	Settings.reload_settings()
