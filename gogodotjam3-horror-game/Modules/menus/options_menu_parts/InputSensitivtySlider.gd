extends HBoxContainer

export (String) var sensitivity_key := "mouse"
export (float) var default_value := 1.0

onready var title := $Title
onready var spin := $SpinBox

func _ready() -> void:
	title.text = sensitivity_key
	spin.value = Settings.sensitivity[sensitivity_key]
	_on_SpinBox_value_changed(spin.value)

func _on_SpinBox_value_changed(value: float) -> void:
	Settings.sensitivity[sensitivity_key] = value
	Settings.reload_settings()

func _on_ResetButton_pressed() -> void:
	spin.value = default_value
	_on_SpinBox_value_changed(spin.value)


