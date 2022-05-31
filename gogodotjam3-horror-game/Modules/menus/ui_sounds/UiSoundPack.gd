extends Node

export (AudioStream) var sfx_focus_enter : AudioStream
export (AudioStream) var sfx_focus_exit : AudioStream
export (AudioStream) var sfx_mouse_enter : AudioStream
export (AudioStream) var sfx_mouse_exit : AudioStream
export (AudioStream) var sfx_button_pressed : AudioStream

onready var audio := $AudioStreamPlayer

func _ready() -> void:
	var parent := get_parent() as Control
	assert(parent, "UISoundPack node must have a control parent")
	assert(audio, "Failed to find AudioStreamPlayer!!!")
	var _clear = parent.connect("focus_entered", self, "_sfx_focus_enter")
	_clear = parent.connect("focus_exited", self, "_sfx_focus_exit")
	_clear = parent.connect("mouse_entered", self, "_sfx_mouse_enter")
	_clear = parent.connect("mouse_exited", self, "_sfx_mouse_exit")
	if parent is Button:
		_clear = (parent as Button).connect("pressed", self, "_sfx_pressed")
	self.name = "SFX_" + parent.name

func _sfx_focus_enter() -> void:
	if not sfx_focus_enter:
		return
	audio.stream = sfx_focus_enter
	_play()

func _sfx_focus_exit() -> void:
	if not sfx_focus_exit:
		return
	audio.stream = sfx_focus_exit
	_play()

func _sfx_mouse_enter() -> void:
	if not sfx_mouse_enter:
		return
	audio.stream = sfx_mouse_enter
	_play()

func _sfx_mouse_exit() -> void:
	if not sfx_mouse_exit:
		return
	audio.stream = sfx_mouse_exit
	_play()

func _sfx_pressed() -> void:
	if not sfx_button_pressed:
		return
	audio.stream = sfx_button_pressed
	_play()

func _play() -> void:
	audio.play()
