extends "res://TierTwoModules/pickup_items/PickupItemCustomScaled.gd"

"""
An item that assigns a value to a specified property with a given value. Any collidable & interactable object that has the given property path will work
"""

# path to expected property on collider
export (String) var desired_property_name :String = "prop_path_not_set!!!"
# value to assign to property
export (bool) var desired_value : bool

func use_item(source : Node) -> void:
	print("Using property setter item")
	var player := source as FirstPersonCharacterBase
	if not player:
		print("failed to find player")
		return
	var inter := player.selection_raycast
	var collider := inter.cached_collider
	if collider:
		var prop_list := collider.get_property_list()
		var flag := false
		for prop in prop_list:
			var n :String = prop["name"]
			if n == desired_property_name:
				flag=true
				break
		if flag:
			if _do_additonal_checks(player, inter, collider):
				collider.set_indexed(desired_property_name, desired_value)
				print("Assigned property [%s] on %s to [%s]" % [str(desired_property_name),str(collider),str(desired_value)])
			else:
				print("Failed additional checks")
		else:
			print("Failed to find property [%s] on %s" % [str(desired_property_name),str(collider)])
			player.set_held_item(null)
	else:
		print("Failed to find a collider!")
		player.set_held_item(null) # should call the remove_item func

func _do_additonal_checks(_player : FirstPersonCharacterBase, _raycast : InteractionRayCast, _collider : Node) -> bool:
	# extend to perform additional checks for assignment
	return true
