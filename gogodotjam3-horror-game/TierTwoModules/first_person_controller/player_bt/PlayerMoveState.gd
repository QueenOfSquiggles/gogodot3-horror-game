extends PlayerState
# 		PlayerMoveState

"""
TODO : Right now, this is a super heavy state. Ideally I'll refactor this out to more sub-nodes. But I gotta figure out how to do that without damaging existing functionaliy
"""

export (NodePath) var sprint_state_path : NodePath
onready var sprint_state := get_node(sprint_state_path) as BaseState
export (NodePath) var jump_state_path : NodePath
onready var jump_state := get_node(jump_state_path) as BaseState


export (bool) var use_gravity := true
export (float) var walk_speed := 10.0
export (float) var sprint_speed := 25.0
export (float) var acceleration := 10.0
export (float) var deacceleration := 5.0
export (bool) var can_move_in_air := true
export (bool) var stop_on_slopes := false

# jump values
export (float) var jump_height := 2.5
export (float) var time_to_peak := 0.3
export (String) var input_forwards := "move_forwards"
export (String) var input_back := "move_backwards"
export (String) var input_left := "move_left"
export (String) var input_right := "move_right"
export (String) var input_jump := "jump"
export (String) var input_sprint := "sprint"
export (String) var toggle_mouse_capture := "ui_cancel"
export (float) var mouse_sensitivity := 0.003

# "Building a better jump" math stolen shamelessly
onready var _gravity := -(2.0 * jump_height) / pow(time_to_peak, 2)
onready var _jump_velocity := -_gravity * time_to_peak
onready var pivot :Spatial= null

var velocity := Vector3()
var is_sprinting := false


func physics_process(delta: float) -> BaseState:
	var movement := _get_movement()
	velocity = velocity.linear_interpolate(movement, acceleration * delta)
	velocity = _apply_gravity(velocity, delta)
	velocity = _apply_jump(velocity, delta)
	if stop_on_slopes and player.is_on_floor() and velocity.y < 0:
		# don't apply gravity if we are already on the floor
		velocity.y = 0
	var _clear = player.move_and_slide(velocity, Vector3.UP, stop_on_slopes)
	return null
	
func _get_movement() -> Vector3:
	if not can_move_in_air and not player.is_on_floor():
		return Vector3()
	var input := Vector2()
	input = Input.get_vector(input_left, input_right, input_back, input_forwards) # gets the normalized vector across the four inputs

	var movement :Vector3= (-camera.global_transform.basis.z * input.y) + (camera.global_transform.basis.x * input.x)
	movement.y = 0
	movement = movement.normalized()
	if Input.is_action_pressed(input_sprint):
		movement *= sprint_speed
		is_sprinting = true
	else:
		movement *= walk_speed
		is_sprinting = false
	return movement

func _apply_gravity(vel : Vector3, delta : float) -> Vector3:
	if use_gravity:
		vel.y += _gravity * delta
	return vel

func _apply_jump(vel : Vector3, _delta : float) -> Vector3:
	if use_gravity and Input.is_action_pressed(input_jump) and player.is_on_floor():
		vel.y = _jump_velocity
	return vel

const view_angle_limit := deg2rad(70)
func input(event: InputEvent) -> BaseState:
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if not pivot:
			pivot = camera.get_parent()
		var mouse_event := event as InputEventMouseMotion
		pivot.rotate_x(-mouse_event.relative.y * mouse_sensitivity)
		player.rotate_y(-mouse_event.relative.x * mouse_sensitivity)
		pivot.rotation.x = clamp(pivot.rotation.x, -view_angle_limit, view_angle_limit)
		
	elif event.is_action_pressed(toggle_mouse_capture):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	else:
		return _handle_state_change_inputs(event)

	return null

func _handle_state_change_inputs(event : InputEvent) -> BaseState:
	
	if event.is_action_pressed(input_sprint) and sprint_state:
		return sprint_state
	return null
	
