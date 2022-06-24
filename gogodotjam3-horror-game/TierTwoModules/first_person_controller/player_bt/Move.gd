extends ActionLeaf
# Move
export (bool) var use_gravity := true
export (float) var walk_speed := 10.0
export (float) var sprint_speed := 25.0
export (float) var acceleration := 10.0
export (float) var deacceleration := 5.0
export (bool) var can_move_in_air := true
export (bool) var stop_on_slopes := true

# jump values
export (float) var jump_height := 2.5
export (float) var time_to_peak := 0.2

export (float) var walking_anim_threshold := 0.2
export (float) var walking_anim_sprint_scalar := 1.7

onready var _gravity := -(2.0 * jump_height) / pow(time_to_peak, 2)
onready var _jump_velocity := -_gravity * time_to_peak

var input_move_vector :Vector2
var velocity :Vector3
var camera :Camera
var sprinting : bool
var jumping :bool
var kine :KinematicBody
var delta : float

onready var tween := Tween.new()

func _ready() -> void:
	add_child(tween)

func tick(actor : Node, bb : Blackboard) -> int:
	input_move_vector = bb.get("move_vector", Vector2.ZERO) as Vector2
	velocity = bb.get("velocity", Vector3.ZERO) as Vector3
	camera = bb.get("camera") as Camera
	sprinting = bb.get("input_sprint", false) as bool
	jumping = bb.get("input_jump", false) as bool
	delta = bb.get("delta", 0.0) as float
	kine = actor as KinematicBody

	assert(kine, "Player Move node requires the BT actor is a KinematicBody")
	
	var movement := _get_movement(input_move_vector)
	movement *= sprint_speed if sprinting else walk_speed

	velocity = velocity.linear_interpolate(movement, acceleration * delta)
	velocity = _apply_gravity(velocity)

	if use_gravity and jumping and kine.is_on_floor():
		velocity.y = _jump_velocity

	if stop_on_slopes and kine.is_on_floor() and velocity.y < 0:
		# don't apply gravity if we are already on the floor
		velocity.y = 0
	var _clear = kine.move_and_slide(velocity, Vector3.UP, stop_on_slopes)
	bb.set("velocity", velocity)

	_manage_anim(bb.get("animation_player") as AnimationPlayer)
	return SUCCESS

func _manage_anim(anim : AnimationPlayer) -> void:
	var walk_move := velocity * Vector3(1.0, 0.0, 1.0)
	var moving := walk_move.length() >= walking_anim_threshold
	var play_speed := walking_anim_sprint_scalar if sprinting else 1.0
	# wow this should really be solved with some kind of state machine!
	# or at least some kind of animation player level logic
	if anim.is_playing() and not moving:
		anim.playback_speed = 1.0
		anim.play("RESET", 0.1) # reset position, with blend
		tween.stop_all()
	elif moving:
		if not anim.is_playing():
			anim.playback_speed = play_speed
			anim.play("walking_anim")
		if not tween.is_active() and abs(anim.playback_speed - play_speed) > 0.1:
			tween.interpolate_property(anim, "playback_speed", anim.playback_speed, play_speed, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()

func _get_movement(input : Vector2) -> Vector3:
	var movement :Vector3= (-camera.global_transform.basis.z * input.y) + (camera.global_transform.basis.x * input.x)
	movement.y = 0
	return movement.normalized()

func _apply_gravity(vel : Vector3) -> Vector3:
	if use_gravity:
		vel.y += _gravity * delta
	return vel
