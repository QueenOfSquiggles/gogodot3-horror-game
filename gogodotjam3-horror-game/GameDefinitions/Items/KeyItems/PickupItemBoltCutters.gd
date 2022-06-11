extends "res://TierTwoModules/pickup_items/PickupItemKey.gd"

func _do_additonal_checks(player : FirstPersonCharacterBase, _raycast : InteractionRayCast, collider : Node) -> bool:
	print("Boltcutters used on: %s" % str(collider.get_path()) )
	return ._do_additonal_checks(player, _raycast, collider)
