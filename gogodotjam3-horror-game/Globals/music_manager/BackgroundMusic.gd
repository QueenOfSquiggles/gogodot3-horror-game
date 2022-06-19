extends Node

export (float) var cross_fade_time := 1.0
export (AudioStream) var audio_stream : AudioStream

func _ready() -> void:
	get_parent().connect("ready", self, "_scene_loaded")

func _scene_loaded() -> void:
	MusicManager.load_music(audio_stream, cross_fade_time)
