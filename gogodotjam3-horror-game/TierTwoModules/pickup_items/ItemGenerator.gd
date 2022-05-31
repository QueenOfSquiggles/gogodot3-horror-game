extends Spatial

export (PackedScene) var packed_scene_to_gen : PackedScene

onready var timer := $Timer
onready var item_holder := $ItemHolder

func _ready() -> void:
	if not packed_scene_to_gen:
		push_error("ItemGenerator missing packed scene [%s]" % str(self))
		queue_free()
		return
	_on_Timer_timeout()

func _on_Timer_timeout() -> void:
	if item_holder.get_child_count() <= 0:
		var inst := packed_scene_to_gen.instance()
		item_holder.add_child(inst)
		if inst is PickupItemBase:
			# clear original parent so it doesn't return
			(inst as PickupItemBase).original_parent = get_tree().current_scene
			inst.scale *= 0.5
			(inst as PickupItemBase).mode = RigidBody.MODE_KINEMATIC
	timer.start()
