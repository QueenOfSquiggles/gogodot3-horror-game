tool
extends HBoxContainer

export (int) var audio_bus_index := 0
export (String) var label_text setget set_label_text

onready var audio := $AudioStreamPlayer
onready var label : Label = $Label
onready var slider := $HSlider
onready var muter := $CheckBox


var bus_name : String

func _ready() -> void:
	bus_name = AudioServer.get_bus_name(audio_bus_index)
	audio.bus = bus_name
	label.text = "options.sfx.title." + label_text
	slider.value = Settings.audio_bus[bus_name].volume
	muter.pressed = Settings.audio_bus[bus_name].muted
	
func set_label_text(value : String) -> void:
	label_text = value
	if not label:
		label = $Label
	label.text = label_text

func _on_HSlider_value_changed(value: float) -> void:
	Settings.audio_bus[bus_name].volume = value
	AudioServer.set_bus_volume_db(audio_bus_index, value)
	Settings.reload_settings()

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	Settings.audio_bus[bus_name].muted = button_pressed
	AudioServer.set_bus_mute(audio_bus_index, button_pressed)
	Settings.reload_settings()

func _on_BtnTest_pressed() -> void:
	audio.play()

func _on_BtnReset_pressed() -> void:
	slider.value = 0
	muter.pressed = false
	Settings.audio_bus[bus_name].volume = 0
	Settings.audio_bus[bus_name].muted = false
	Settings.reload_settings()

