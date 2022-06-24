extends Control

export (String) var menu_scene_path := "res://Modules/menus/MainMenu.tscn"

export var speed_rate := 10.0

onready var anim := $AnimationPlayer

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel") or event.is_action("pause"):
		on_credits_end()
	elif event.is_action("move_backwards") or event.is_action("ui_down"):
		if event.is_pressed():
			anim.playback_speed = speed_rate
		else:
			anim.playback_speed = 1.0
			

func on_credits_end() -> void:
	SceneManagement.load_scene(menu_scene_path)
