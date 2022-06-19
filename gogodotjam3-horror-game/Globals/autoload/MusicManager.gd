extends Node

var track_0 : AudioStreamPlayer
var track_1 : AudioStreamPlayer
var tween : Tween
var active_track := 0

const EFFECTIVE_MUTE_VALUE := -60.0

func _ready() -> void:
	tween = Tween.new()
	track_0 = _create_audio_track()
	track_1 = _create_audio_track()
	add_child(track_0)
	add_child(track_1)
	add_child(tween)
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func _create_audio_track() -> AudioStreamPlayer:
	var track := AudioStreamPlayer.new()
	track.bus = "Music"
	return track

func load_music(stream : AudioStream, cross_fade_time : float = 0.5) -> void:
	if _active().stream == stream:
		return
	if cross_fade_time > 0.0:
		active_track = 1 if active_track == 0 else 0

		
	_active().stop()
	_active().stream = stream
	_active().volume_db = 0.0 # general db for music
	_active().play()

	if cross_fade_time > 0.0:
		tween.remove_all() # force all to be done?
		tween.interpolate_property(_idle(), "volume_db", 0.0, EFFECTIVE_MUTE_VALUE, cross_fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.interpolate_property(_active(), "volume_db", EFFECTIVE_MUTE_VALUE, 0.0, cross_fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.01)
		tween.start()
		yield(tween, "tween_all_completed")
		_idle().stop()

func _active() -> AudioStreamPlayer:
	match active_track:
		0:
			return track_0
		1:
			return track_1
	return null

func _idle() -> AudioStreamPlayer:
	match active_track:
		0:
			return track_1
		1:
			return track_0
	return null
