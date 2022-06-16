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
	select_pane.open()
	var bind_info :Dictionary = yield(select_pane, "key_selected")
	yield(VisualServer, "frame_post_draw")
	print("Assiging action [%s] to binding\n\t%s" % [slot.input_action_name, str(bind_info)])
	Settings.control_bindings[slot.input_action_name] = bind_info
	Settings.reload_settings()


func _on_BtnResetAll_pressed() -> void:
	for action in Settings.control_bindings.keys():
		Settings.control_bindings[action] = {
			"bind" : -1,
			"type" : -1
		}
	Settings.reload_settings()
