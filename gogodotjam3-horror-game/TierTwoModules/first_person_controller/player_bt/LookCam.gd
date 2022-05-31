extends Leaf
# Look Cam

export (float) var mouse_sensitivity := 0.003
export (float) var view_angle_limit := 70.0

onready var rad_view_lim := deg2rad(view_angle_limit)

func tick(actor : Node, bb : Blackboard) -> int:
	var mouse_delta := bb.get("mouse_delta", Vector2.ZERO) as Vector2
	var pivot := bb.get("cam_pivot") as Spatial
	var kine := actor as KinematicBody
	var toggle_capture := bb.get("input_toggle_mouse_capture", false) as bool
	if toggle_capture:
		pass
		#		Set this on a time limiter
#		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		else:
#			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if mouse_delta.length_squared() > 0:
		pivot.rotate_x(-mouse_delta.y * mouse_sensitivity)
		kine.rotate_y(-mouse_delta.x * mouse_sensitivity)
		pivot.rotation.x = clamp(pivot.rotation.x, -rad_view_lim, rad_view_lim)
	
	return SUCCESS
