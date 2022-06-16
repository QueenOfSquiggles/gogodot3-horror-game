extends Spatial

export (bool) var play_once := true
export (String) var group_limiter := "none"
onready var sfx := $sfx_stinger

var _locked := false

func _body_entered(body: Node) -> void:
	if _locked:
		return
	if not group_limiter == "none":
		if not body.is_in_group(group_limiter):
			return
	sfx.play()
	if play_once:
		_locked = true
		var _clr := sfx.connect("finished", self, "queue_free", [], CONNECT_ONESHOT)
