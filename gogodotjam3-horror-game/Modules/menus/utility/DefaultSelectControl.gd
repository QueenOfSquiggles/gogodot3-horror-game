extends Node

func _ready() -> void:
	var par := get_parent() as Control
	if not par:
		push_error("%s must have a Control node for parent" % str(self))
		return
	else:	
		par.grab_focus()
	queue_free() # served its purpose, delete
