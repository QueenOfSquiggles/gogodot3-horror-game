extends PickupItemBase

export (String) var title_key := "title_key"
export(String, MULTILINE) var text_key := "text_key"

func _ready() -> void:
	self.item_name = title_key

func use_item(_player : FirstPersonCharacterBase) -> void:
	Readables.display_readable(title_key, text_key)
