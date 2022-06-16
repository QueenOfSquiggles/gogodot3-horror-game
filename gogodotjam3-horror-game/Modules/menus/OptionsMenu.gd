extends Control

export (String) var main_menu_path : String
export (PackedScene) var ui_sound_pack : PackedScene
onready var pages := $"OptionsCategories/Pages"
onready var tab_buttons := $Tabs

func _ready() -> void:
	_generate_tab_buttons()
	
func _generate_tab_buttons() -> void:
	var tabs := pages.get_children()
	for tab in tabs:
		var btn := Button.new()
		tab_buttons.add_child(btn)
		btn.text = "options." + tab.name
		btn.size_flags_horizontal = SIZE_EXPAND_FILL
		var _clear = btn.connect("pressed", self, "_tab_button_pressed", [tab.get_index()])
		var sfx := ui_sound_pack.instance()
		btn.add_child(sfx)

func _tab_button_pressed(index : int) -> void:
	pages.current_tab = index
	
func _on_BtnMainMenu_pressed() -> void:
	SceneManagement.load_scene(main_menu_path)

func _on_BtnDeleteSaveData_pressed() -> void:
	SaveData.delete_data()
