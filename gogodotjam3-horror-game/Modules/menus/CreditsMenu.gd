extends Control

export (String) var main_menu_path := "res://Modules/menus/MainMenu.tscn"
export (String) var credits_scroll_path := "res://Modules/menus/CreditsScroll.tscn"


func _on_BtnMainMenu_pressed() -> void:
	SceneManagement.load_scene(main_menu_path)


func _on_BtnViewScroll_pressed() -> void:
	SceneManagement.load_scene(credits_scroll_path)
