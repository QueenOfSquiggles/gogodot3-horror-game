extends KinematicBody
class_name FirstPersonCharacterBase


onready var bt := $PlayerBehaviourTree
onready var anim_player := $AnimationPlayer
onready var held_item_root := $Pivot/Camera/held_object
onready var selection_raycast : InteractionRayCast = $"Pivot/Camera/SelectionCast"
onready var drop_item_pos := $Pivot/Camera/DropPosition

signal interactable_select_started(collider)
signal interactable_select_ended(collider)

var anim_queue := []

func _ready() -> void:
	var _clear = anim_player.connect("animation_finished", self, "_on_anim_done")
	_clear = selection_raycast.connect("on_start_collide", self, "_interact_proxy", [true])
	_clear = selection_raycast.connect("on_end_collide", self, "_interact_proxy", [false])
	held_item_root.translation.x = -0.6
	held_item_root.translation.y = -0.6
	print(held_item_root.translation)

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
	if held_item_root.get_child_count() > 0:
		var cur_item := held_item_root.get_child(0)
		if cur_item and cur_item.has_method("remove_item"):
			held_item_root.remove_child(cur_item)
			drop_item_pos.add_child(cur_item)
			cur_item.remove_item(self)
	if item:
		# check here so we can pass null to clear held items
		item.get_parent().remove_child(item)
		held_item_root.add_child(item)
		if item.has_method("pickup_item"):
			item.pickup_item(self)

func set_global_lock(is_locked : bool) -> void:
	Globals.player_occupied = is_locked
	print("Player was set as occupied=%s" % str(is_locked))
