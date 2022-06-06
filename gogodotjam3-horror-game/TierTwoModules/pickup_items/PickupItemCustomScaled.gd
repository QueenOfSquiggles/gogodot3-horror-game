extends PickupItemBase

export (Vector3) var world_scale := Vector3.ONE
export (Vector3) var held_scale := Vector3.ONE

export (Array, NodePath) var scale_children : Array

func _ready() -> void:
	_set_scales(world_scale)

func pickup_item(player : Node) -> void:
	.pickup_item(player)
	self.transform = Transform.IDENTITY
	_set_scales(held_scale)

func remove_item(player : Node) -> void:
	.remove_item(player)
	_set_scales(world_scale)
	self.mode = RigidBody.MODE_RIGID

func _set_scales(scale : Vector3) -> void:
	for path in scale_children:
		var node := get_node(path) as Spatial
		if node:
			node.scale = scale
		else:
			print("failed to find spatial node at : ", path)
