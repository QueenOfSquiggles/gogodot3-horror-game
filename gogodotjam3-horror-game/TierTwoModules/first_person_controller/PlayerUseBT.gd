extends KinematicBody
class_name FirstPersonCharacterBase


onready var bt := $PlayerBehaviourTree
onready var anim_player := $AnimationPlayer
onready var selection_raycast : InteractionRayCast = $Pivot/Camera/InteractionDetector
onready var remote_trans := $Pivot/Camera/RemoteTransform
onready var remote_trans_dummy := ($Pivot/Camera/Dummy).get_path()
signal interactable_select_started(collider)
signal interactable_select_ended(collider)

var anim_queue := []

func _ready() -> void:
	var _clear = anim_player.connect("animation_finished", self, "_on_anim_done")
	_clear = selection_raycast.connect("on_start_collide", self, "_interact_proxy", [true])
	_clear = selection_raycast.connect("on_end_collide", self, "_interact_proxy", [false])

func _interact_proxy(collider : Object, starting : bool) -> void:
	if starting:
		emit_signal("interactable_select_started", collider)
	else:
		emit_signal("interactable_select_ended", collider)

func _physics_process(delta: float) -> void:
	bt.tick_tree(delta)

func play_animation(anim : String) -> void:
	if anim_player.is_playing():
		anim_queue.push_back(anim)
	else:
		anim_player.stop()
		anim_player.play(anim)

func _on_anim_done(anim_name : String) -> void:
	if anim_name == "RESET":
		return
	if not anim_player.get_animation(anim_name).loop and not anim_queue.empty():
		var next := anim_queue.pop_front() as String
		if next and not next.empty():
			anim_player.play(next)

func set_held_item(item : Spatial = null) -> void:
	var cur_item := get_held_item()
	if cur_item and cur_item.has_method("remove_item"):
		remote_trans.remote_path = remote_trans_dummy
		remote_trans.rotation = Vector3.ZERO
		cur_item.remove_item(self)
	if item:
		remote_trans.remote_path = item.get_path()
		# check here so we can pass null to clear held items
		if item.has_method("pickup_item"):
			item.pickup_item(self)

func get_held_item() -> Spatial:
	if remote_trans.remote_path == remote_trans_dummy:
		return null
	return remote_trans.get_node(remote_trans.remote_path) as Spatial

func set_global_lock(is_locked : bool) -> void:
	Globals.player_occupied = is_locked
	print("Player was set as occupied=%s" % str(is_locked))
