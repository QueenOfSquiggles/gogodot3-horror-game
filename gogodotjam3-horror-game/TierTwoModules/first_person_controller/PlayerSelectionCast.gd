extends RayCast
class_name InteractionRayCast

export (float) var cache_time := 0.5

signal on_start_collide_mt
signal on_end_collide_mt

signal on_start_collide(collider)
signal on_end_collide(collider)

var cached_collider : Node = null
var _timer := 0.0

func _physics_process(delta: float) -> void:
	if is_colliding():
		var temp := get_collider()
		if temp.has_method("interact"):
			if not temp == cached_collider:
				emit_signal("on_start_collide_mt")
				emit_signal("on_start_collide", cached_collider)
			cached_collider = temp
			_timer = cache_time
	else:
		if _timer > 0:
			_timer -= delta
		elif cached_collider:
			# emit the signal before we set null so cleanup can be done
			emit_signal("on_end_collide", cached_collider)
			emit_signal("on_end_collide_mt")
			cached_collider = null
