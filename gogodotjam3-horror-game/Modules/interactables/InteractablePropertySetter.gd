extends "res://Modules/interactables/InteractableBase.gd"
"""
An interactable object which can assign pretty much any basic value to a desired property path on a specified node. This was originally created to enable light switches, but it also could be used for a wide variety of cases where interacting with one object should change something on a different node
"""


enum PropertyMode {
	SINGLE, # always use start index value
	ARRAY_FORWARDS, # loop forwards through array from start
	ARRAY_BACKWARDS, # loop backwards through array from start
	ARRAY_PING_PONG, # ping pong through array from start
	ARRAY_RANDOM # random select
}

export (NodePath) var target_node : NodePath
export (String) var target_property := ""
export (int, -1, 99999) var use_limit := -1
export (PropertyMode) var property_mode := PropertyMode.SINGLE
export (Array) var property_values_array := []
export (int) var start_index := 0

onready var uses := use_limit
onready var cur_index := start_index

var index_dir := 1

func _ready() -> void:
	randomize()

func interact(_source : Node) -> void:
	var value = property_values_array[cur_index]
	match (property_mode):
		PropertyMode.ARRAY_FORWARDS:
			cur_index += 1
			cur_index %= property_values_array.size()
		PropertyMode.ARRAY_BACKWARDS:
			cur_index -= 1
			cur_index %= property_values_array.size()
		PropertyMode.ARRAY_PING_PONG:
			if cur_index == property_values_array.size() -1 or cur_index == 0:
				index_dir *= -1
			cur_index += index_dir
		PropertyMode.ARRAY_RANDOM:
			cur_index = randi() % property_values_array.size()
	_set_prop(value)

func _set_prop(value) -> void:
	var node : Node = get_node(target_node)
	if is_instance_valid(node):
		node.set_indexed(target_property, value)

