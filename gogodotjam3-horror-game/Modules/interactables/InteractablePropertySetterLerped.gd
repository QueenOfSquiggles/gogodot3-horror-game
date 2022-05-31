extends "res://Modules/interactables/InteractablePropertySetter.gd"

enum EaseType {
	EASE_IN = 0,
	EASE_OUT = 1,
	EASE_IN_OUT = 2,
	EASE_OUT_IN = 3
}


enum TransitionType {
	TRANS_LINEAR = 0,
	TRANS_SINE = 1,
	TRANS_QUINT = 2,
	TRANS_QUART = 3,
	TRANS_QUAD = 4,
	TRANS_EXPO = 5,
	TRANS_ELASTIC = 6,
	TRANS_CUBIC = 7,
	TRANS_CIRC = 8,
	TRANS_BOUNCE = 9,
	TRANS_BACK = 10
}



export (float, 0.0, 999.0) var lerp_time := 2.0
export (EaseType) var ease_type := EaseType.EASE_IN_OUT
export (TransitionType) var transition_type := TransitionType.TRANS_LINEAR
onready var tween := $Tween



func _set_prop(value) -> void:
	var node : Node = get_node(target_node)
	if is_instance_valid(node):
		var cur_val = node.get_indexed(target_property)
		tween.stop_all() # only one at a time
		tween.interpolate_property(node, target_property, cur_val, value, lerp_time, transition_type, ease_type)
		tween.start()
		

