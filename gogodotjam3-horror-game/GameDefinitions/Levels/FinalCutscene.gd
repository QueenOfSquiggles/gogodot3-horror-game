extends Spatial

export (String) var credit_scroll_path : String
onready var anim := $AnimationPlayer

func _ready() -> void:
	anim.play("RESET")
	EventBus.connect("final_cutscene", self, "_play_final_cutscene", [], CONNECT_DEFERRED)

func _play_final_cutscene() -> void:
	anim.play("FinalCutscene")

func end_cutscene() -> void:
	Globals.unlock_mouse()
	SceneManagement.load_scene(credit_scroll_path)
