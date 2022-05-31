extends "res://TierTwoModules/pickup_items/PickupItemCustomScaled.gd"

"""
An item that assigns a value to a specified property with a given value. Any collidable & interactable object that has the given property path will work
"""

# path to expected property on collider
export (String) var desired_property_name :String = "prop_path_not_set!!!"
# value to assign to property
export (bool) var desired_value : bool

func use_item(player : FirstPersonCharacterBase) -> void:
	var inter := player.selection_raycast
	var collider := inter.cached_collider
	if collider:
		print("collider present : ", collider)
		var prop_list := collider.get_property_list()
		var flag := false
		for prop in prop_list:
			var n :String = prop["name"]
			#print("property found : [%s] desired [%s]" % [n, desired_property_name])
			if n == desired_property_name:
				print("found property on collider!!!")
				flag=true
				break
		if flag:
			print("property is in collider : ", desired_property_name)
			if _do_additonal_checks(player, inter, collider):
				print("additional checks passed")
				inter.cached_collider.set_indexed(desired_property_name, desired_value)
				print("Set property [%s] to [%s] on node [%s]" % [str(desired_property_name),str(desired_value),str(inter.cached_collider),])
		else:
			player.set_held_item(null)
	else:
		player.set_held_item(null) # should call the remove_item func

func _do_additonal_checks(_player : FirstPersonCharacterBase, _raycast : InteractionRayCast, _collider : Node) -> bool:
	# extend to perform additional checks for assignment
	return true
