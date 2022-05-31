extends Spatial

export (String) var keyed_name := "door_001"

func _ready() -> void:
	var sub_script := $"doorwayFront(Clone)/door/KinematicBody"
	sub_script.keyed_name = keyed_name
