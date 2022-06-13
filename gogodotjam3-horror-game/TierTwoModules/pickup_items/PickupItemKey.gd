extends "res://TierTwoModules/pickup_items/PickupItemPropertySetter.gd"

export (bool) var is_skeleton_key := false
export (bool) var destroy_after_use := false
export (String) var keyed_name := "door_001"

func _do_additonal_checks(player : FirstPersonCharacterBase, _raycast : InteractionRayCast, collider : Node) -> bool:
	var flag :bool = ("keyed_name" in collider) and (collider.keyed_name == keyed_name)
	
	if is_skeleton_key:
		# skeleton key is for any door
		flag = true
	if flag and destroy_after_use:
		player.set_held_item(null) # remove from inventory system
		call_deferred("queue_free") # next frame remove from tree
	return flag
