extends Area

export (String) var group_detect := "player"
export (int) var bus_index := 1
export (int) var bus_reverb_effect_index := 0
export (AudioEffectReverb) var reverb_settings : AudioEffectReverb

func _on_ReverbArea_body_entered(body: Node) -> void:
	if body.is_in_group(group_detect):
		_apply_reverb()

func _apply_reverb() -> void:
	if reverb_settings:
		AudioServer.remove_bus_effect(bus_index, bus_reverb_effect_index)
		AudioServer.add_bus_effect(bus_index, reverb_settings, bus_reverb_effect_index)
		AudioServer.set_bus_effect_enabled(bus_index, bus_reverb_effect_index, true)
	else:
		AudioServer.set_bus_effect_enabled(bus_index, bus_reverb_effect_index, false)
		
