extends Control

export (PackedScene) var game_scene_path : PackedScene
export (PackedScene) var options_menu : PackedScene
export (PackedScene) var credits_menu : PackedScene

onready var btn_continue := $"GameButtons/VBoxContainer/BtnContinue"
onready var btn_play := $"GameButtons/VBoxContainer/BtnNewGame"
onready var anim := $AnimationPlayer


func _ready() -> void:
	if not game_scene_path:
		return
	var temp = game_scene_path.instance()
	if not SaveData.does_save_data_exist_for(temp.name):
		btn_continue.queue_free()
		btn_play.grab_focus()
	else:
		btn_continue.grab_focus()

func _on_BtnContinue_pressed() -> void:
	if game_scene_path:
		SceneManagement.load_scene(game_scene_path.resource_path, true)
		anim.play("transition_out")

func _on_BtnNewGame_pressed() -> void:
	if not game_scene_path:
		return
	SaveData.delete_data()
	yield(VisualServer, "frame_post_draw") # one frame
	SceneManagement.load_scene(game_scene_path.resource_path, true)
	anim.play("transition_out")


func _on_BtnOptions_pressed() -> void:
	if options_menu:
		SceneManagement.load_scene(options_menu.resource_path)
		anim.play("transition_out")


func _on_BtnCredits_pressed() -> void:
	if credits_menu:
		SceneManagement.load_scene(credits_menu.resource_path)
		anim.play("transition_out")


func _on_BtnQuit_pressed() -> void:
	anim.play("transition_out")
	yield(get_tree().create_timer(0.9), "timeout")
	get_tree().quit()
