extends Node

"""
SceneManagement.gd
---
An autoload for handling scene loading and unloading.

"""
export (float) var test := 0.0
const DEFAULT_LOADING_SCREEN := "res://Globals/scene_management/DefaultLoadingScreen.tscn"
const SCENE_TRANSITION_SCENE := "res://Globals/scene_management/SceneTransition.tscn"

var loading_scene : LoadingScreen
var scene_transition : Node = null

func _ready() -> void:
	scene_transition = load(SCENE_TRANSITION_SCENE).instance()
	call_deferred("add_child", scene_transition)


func load_scene(path : String, use_loading_screen : bool = false) -> void:
	"""
	Doesn't use a loading screen by default because we should know whether or not the scene we are loading is big enough to require one
	"""
	var anim := scene_transition.get_node("AnimationPlayer") as AnimationPlayer
	anim.play("fade_out")
	Subtitles.clear_subtitles()
	if use_loading_screen:
		_load_gradual(path)
	else:
		yield(anim, "animation_finished")
		_load_instant(path)
		anim.play_backwards("fade_out")

func _load_instant(path: String) -> void:
	var err := get_tree().change_scene(path)
	Subtitles.subtitles_enabled = Settings.subtitles_enabled
	Subtitles.clear_subtitles()
	if err != OK:
		push_error("Failed to change scene to %s; Error = %s" % [path, str(err)])	

var loader : ResourceInteractiveLoader
var loading_title : String = "not_filled"
var current_loading_scene_name := ""
const form_title := "Loading scene [%s] Stage (%d / %d)"
var wait_frames
const time_max := 10
var current_scene

func _load_gradual(path: String) -> void:
	Subtitles.subtitles_enabled = false
	current_loading_scene_name = path
	current_scene = get_tree().current_scene
	loader = ResourceLoader.load_interactive(path)
	assert(loader, "Failed to create resource loader for %s" % path)
	call_deferred("set_process", true)
	current_scene.queue_free()
	_load_instant(DEFAULT_LOADING_SCREEN)
	wait_frames = 1

func _process(_delta: float) -> void:
	if loader == null:
		set_process(false)
		return
	if wait_frames > 0:
		wait_frames -= 1
		loading_scene = get_tree().current_scene as LoadingScreen
		assert(loading_scene, "Failed to change to the loading screen!!!")
		return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max:
		var err := loader.poll()

		if err == ERR_FILE_EOF:
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			loading_title = form_title % [current_loading_scene_name, loader.get_stage(), loader.get_stage_count()]
			update_progress()
		else:
			assert(false, "Something failed! ErrorCode : %s" % err)
			loader = null
			break

func set_new_scene(scene : PackedScene) -> void:
	current_scene = scene
	var err := get_tree().change_scene_to(scene)
	if err != OK:
		push_error("Failed to change scene to %s; Error = %s" % [str(scene), str(err)])
	var anim := scene_transition.get_node("AnimationPlayer") as AnimationPlayer
	anim.play_backwards("fade_out")



func update_progress() -> void:
	var progress := float(loader.get_stage()) / float(loader.get_stage_count())
	loading_scene.update_progress(loading_title, progress)
