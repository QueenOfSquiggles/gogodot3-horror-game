extends Control

export (String) var prompt_format_string := "Pick up %s"
onready var label := $Label

func _ready() -> void:
	label.text = ""

func _on_FirstPersonCharacterBase_interactable_select_started(collider) -> void:
	if not collider:
		return
	if "item_name" in collider:
		label.text = prompt_format_string % tr(collider.item_name)
	elif "interact_prompt" in collider:
		label.text = tr(collider.interact_prompt)

func _on_interactable_select_ended(_collider) -> void:
	label.text = ""
