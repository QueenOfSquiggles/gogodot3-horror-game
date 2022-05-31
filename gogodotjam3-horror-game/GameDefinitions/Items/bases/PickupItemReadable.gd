extends PickupItemBase

export (String) var title_key := "title_key"
export(String) var text_key := "text_key"

func use_item(player : FirstPersonCharacterBase) -> void:
	Readables.display_readable(title_key, text_key)
	var _clr := Readables.connect("popup_closed", self, "_popup_closed", [player], CONNECT_ONESHOT)

func _popup_closed(player : FirstPersonCharacterBase) -> void:
	player.set_held_item(null) # drop item
