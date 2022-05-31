extends Area

export (bool) var lock_player := true
export (bool) var delete_on_completed := true
export (String) var anim_name := "cutscene"
# pretty much everything else can be handled through the animation player.
export (NodePath) var anim_player_path : NodePath

onready var anim := get_node(anim_player_path) as AnimationPlayer

func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if lock_player: Globals.player_occupied = true
		anim.play(anim_name)
		yield(anim, "animation_finished")
		if lock_player: Globals.player_occupied = false
		if delete_on_completed:
			queue_free()
