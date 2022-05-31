extends Node
"""
Globals handles some common global attributes that can affect other scripts across the game.
Kindof acts as a middle-man between certain modules
"""

"""
		Player Occupied
"""
signal player_occupied_changed(value)

var player_occupied := false setget _set_player_occupied

func _set_player_occupied(value : bool) -> void:
	player_occupied = value
	emit_signal("player_occupied_changed", player_occupied)

func set_player_occupied_dialogue(value : Array) -> void:
	var s_val := value[0] as String
	var val :bool= s_val.to_lower().begins_with("true")
	player_occupied = val

"""
	
		Mouse Lock/Unlock
	
"""

func unlock_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func lock_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

"""

		Pausing

"""

func set_paused(is_paused : bool) -> void:
	get_tree().paused = is_paused
