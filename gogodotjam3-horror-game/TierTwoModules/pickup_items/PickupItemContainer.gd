extends "res://TierTwoModules/pickup_items/PickupItemCustomScaled.gd"
class_name PickupItemContainer

export (PackedScene) var container_contents_scene : PackedScene

func open_pickup_container() -> void:
	print("Attempting to open container!")
	if container_contents_scene:
		var inst :Spatial = container_contents_scene.instance()
		get_parent().add_child(inst)
		inst.global_transform = self.global_transform
		inst.rotation = self.rotation
		call_deferred("queue_free")
