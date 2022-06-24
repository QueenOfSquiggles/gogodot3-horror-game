tool
extends PanelContainer

export (String) var title := "" setget _set_title
export (Array, String) var members := [] setget _set_members

onready var lbl_title := $MarginContainer/VBoxContainer/TitleLabel

onready var lbl_members := $MarginContainer/VBoxContainer/MembersLabel

func _ready() -> void:
	_set_title(title)
	_set_members(members)

func _set_title(n_title : String) -> void:
	title = n_title
	if lbl_title:
		lbl_title.text = tr(title)

func _set_members(n_members : Array) -> void:
	members = n_members
	if lbl_members:
		var composite := " | "
		for m in members:
			composite += tr(m) + " | "
		lbl_members.text = composite
