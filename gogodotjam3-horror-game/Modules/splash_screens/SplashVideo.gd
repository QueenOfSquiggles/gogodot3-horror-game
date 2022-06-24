extends Control

export (String) var menu_scene_path := "res://Modules/menus/MainMenu.tscn"

onready var vid_qos : VideoPlayer = $Video_QueenOfSquiggles
onready var vid_godot : VideoPlayer = $Video_Godot


func _ready() -> void:
	vid_qos.connect("finished", self, "_vid_qos_done")
	vid_godot.connect("finished", self, "_vid_godot_done")
	vid_godot.visible = false
	vid_qos.play()

func _vid_qos_done() -> void:
	vid_godot.visible = true
	vid_qos.visible = false
	vid_godot.call_deferred("play")

func _vid_godot_done() -> void:
	SceneManagement.load_scene(menu_scene_path)

func _input(event: InputEvent) -> void:
	if event.is_action("pause") or event.is_action("ui_cancel"):
		_vid_godot_done() # force end
