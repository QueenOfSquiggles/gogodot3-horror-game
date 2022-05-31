extends Leaf
# Load Inputs
export (String) var input_forwards := "move_forwards"
export (String) var input_back := "move_backwards"
export (String) var input_left := "move_left"
export (String) var input_right := "move_right"

export (String) var input_jump := "jump"
export (String) var input_sprint := "sprint"
export (String) var toggle_mouse_capture := "ui_cancel"

export (String) var input_interact := "interact"
export (String) var input_use_item := "use_item"
export (String) var input_toggle_rotate_item := "toggle_rotate_item"


var last_mouse_pos := Vector2()
var cache_mouse_pos := Vector2()
func tick(_actor : Node, bb : Blackboard) -> int:
	# get values
	var move_vector := Input.get_vector(input_left, input_right, input_back, input_forwards)
	var b_sprint := Input.is_action_pressed(input_sprint)
	var b_jump := Input.is_action_pressed(input_jump)
	var mouse_delta := _get_mouse_delta()
	var b_toggle_mouse_capture := Input.is_action_pressed(toggle_mouse_capture)
	var b_interact := Input.is_action_just_pressed(input_interact)
	var b_use_item := Input.is_action_just_pressed(input_use_item)
	var b_toggle_rotate_item := Input.is_action_pressed(input_toggle_rotate_item)
	
	# set values
	bb.set("move_vector", move_vector)
	bb.set("input_sprint", b_sprint)
	bb.set("input_jump", b_jump)
	bb.set("input_toggle_mouse_capture", b_toggle_mouse_capture)
	bb.set("mouse_delta", mouse_delta)
	bb.set("input_interact", b_interact)
	bb.set("input_use_item", b_use_item)
	bb.set("input_toggle_rotate_item", b_toggle_rotate_item)
	
	return SUCCESS

func _get_mouse_delta() -> Vector2:
	var delta = cache_mouse_pos - last_mouse_pos
	last_mouse_pos = cache_mouse_pos
	return delta


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_event := event as InputEventMouseMotion
		cache_mouse_pos += mouse_event.relative
