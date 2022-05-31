extends Spatial
class_name AudioLib3D

func play(name : String = "") -> void:
	if name.empty():
		var c := get_child(randi() % get_child_count())
		assert(c.has_method("play"), "Children of an AudioLib must have a valid 'play' function")
		c.play()
	else:
		for c in get_children():
			if c.name == name:
				assert(c.has_method("play"), "Children of an AudioLib must have a valid 'play' function")
				c.play()
		
