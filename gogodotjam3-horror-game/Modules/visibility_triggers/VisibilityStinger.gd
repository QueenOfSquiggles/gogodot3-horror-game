extends VisibilityNotifier

export (bool) var execute_once := true
export (bool) var use_raycast_check := true
export (float) var visibility_time := 0.5

var executed := false
var current_timer : SceneTreeTimer = null
var camera_cache : NodePath

onready var audio := $StingerAudio
onready var raycast := $RayCast


func _on_VisibilityStinger_camera_entered(camera: Camera) -> void:
	if executed and execute_once:
		return
	camera_cache = camera.get_path()
	if not (use_raycast_check and _raycast_check(camera)):
		# raycast failed, not actually visible
		return
	current_timer = get_tree().create_timer(visibility_time, false)
	yield(current_timer, "timeout")
	if not is_instance_valid(current_timer):
		return
	executed = true
	if execute_once:
		audio.connect("finished", self, "queue_free", [], CONNECT_DEFERRED)
	audio.play()

func _physics_process(_delta: float) -> void:
	if is_on_screen() and not executed and current_timer == null and camera_cache != "":
		var cam := get_node(camera_cache)
		_on_VisibilityStinger_camera_entered(cam)
		

func _raycast_check(camera : Camera) -> bool:
	var delta_pos :Vector3= camera.global_transform.origin - self.global_transform.origin
	raycast.cast_to = delta_pos * 0.99 # stop short of camera position
	raycast.force_raycast_update()
	return not raycast.is_colliding()

func _on_VisibilityStinger_camera_exited(camera: Camera) -> void:
	current_timer = null
	camera_cache = ""