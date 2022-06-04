extends MeshInstance


func delete_dirty_water() -> void:
	$StaticBody.queue_free()
