extends Node

func _ready() -> void:
	var _clear = get_parent().connect("ready", self, "load_save_data")

func save_data() -> void:
	SaveData.save_data()

func load_save_data() -> void:
	SaveData.load_save_data()
	var pers := get_tree().get_nodes_in_group("persist")
	print("Level Saver found %s persist nodes in the scene tree" % str(pers.size()))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		save_data()
