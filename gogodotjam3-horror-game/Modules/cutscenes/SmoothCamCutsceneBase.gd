extends "res://Modules/cutscenes/CutsceneBase.gd"

export (float) var smooth_time := 1.0
onready var cam := $Camera
onready var tween := $Tween


func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("player"): # checks are double but worth it
		anim.play("RESET") # get initial pos ideally
		var current_cam := get_viewport().get_camera()
		current_cam.current = false
		cam.current = true
		var target_trans :=  current_cam.global_transform
		var target_rotation := current_cam.rotation
		# lerp transform and rotation for smooth_time seconds
		tween.interpolate_property(cam, "global_transform", target_trans, cam.global_transform, smooth_time)
		tween.interpolate_property(cam, "rotation", target_rotation, cam.rotation, smooth_time)
		tween.start()
		print("tweening camera pos [%s] -> [%s]" % [str(current_cam.name), str(cam.name)])
		yield(tween, "tween_all_completed") # await all tweens completed
		print("playing cutscene animation")
		yield(._on_Area_body_entered(body), "completed") # do normal script
		print("doing cutscene cleanup")
		cam.current = false
		current_cam.current = false
