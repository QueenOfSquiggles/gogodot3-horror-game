extends Spatial

export (String) var keyed_name := "door_001"

onready var door_part := $"doorwayFront/door001/KinematicBody"

func _ready() -> void:
	door_part.keyed_name = keyed_name

func save_data() -> Dictionary:
	return {"is_locked" : door_part.locked}

func load_save_data(data : Dictionary):
	if "is_locked" in data:
		door_part.locked = data.is_locked as bool
