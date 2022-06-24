tool
extends PanelContainer

export (String) var text := "| " setget _set_text 

onready var label := $MarginContainer/Label

func _ready() -> void:
	_set_text(text)

func _set_text(txt : String) -> void:
	text = txt
	if label:
		label.text = txt
