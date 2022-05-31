extends Node


var _locks := {
	"default" : false
}

# signature : (String, bool)
signal lock_changed(lock_name, value)

func _ready() -> void:
	# no processing for this, we just handle events here
	set_process(false)
	set_physics_process(false)


func set_lock(lock_name : String, value : bool) -> void:
	"""
	Assign the value of a lock (creates a new lock if it doesn't already exist) and emits a signal for the name and value of the lock. This signal can be observed externally and used by any door, lock, gate, or structure which has a binary state. This decouples the keys and locks of a system while still allowing specific keys to unlock specific locks.
	The keys and locks need not be a literal key and/or lock but can be anything that would need to be triggered.
	"""
	var changed := true
	if lock_name in _locks:
		if _locks[lock_name] == value:
			changed = false # no change in value
	_locks[lock_name] = value
	if changed:
		# only emit the signal when the value is changed, not just when it is assigned. Save processing in scenes with many locks.
		emit_signal("lock_changed", lock_name, value)

func get_lock(lock_name : String) -> bool:
	return _locks[lock_name]

func clear_lock(lock_name : String) -> void:
	# frees up memory if the lock is no longer in use
	var _err = _locks.erase(lock_name)
