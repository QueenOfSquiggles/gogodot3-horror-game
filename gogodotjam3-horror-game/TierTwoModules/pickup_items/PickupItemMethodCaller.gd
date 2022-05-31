extends "res://TierTwoModules/pickup_items/PickupItemCustomScaled.gd"

export (String) var method_to_call := "unset"
export (bool) var method_call_deferred := false
 
func use_item(player : FirstPersonCharacterBase) -> void:
	var inter := player.selection_raycast
	var collider := inter.cached_collider
	if collider and is_instance_valid(collider) and  collider.has_method(method_to_call):
		if method_call_deferred:
			collider.call_deferred(method_to_call)
		else:
			collider.call(method_to_call)
	else:
		player.set_held_item(null) # should call the remove_item func
