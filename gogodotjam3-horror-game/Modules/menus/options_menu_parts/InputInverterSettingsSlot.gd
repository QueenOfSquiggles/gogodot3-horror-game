extends HBoxContainer

export (String) var input_key := "mouse"

onready var label := $Label
onready var check_x := $Check_X
onready var check_y := $Check_Y


func _ready() -> void:
	label.text = input_key
	var invert :Array = Settings.look_inversions[input_key]
	check_x.pressed = (invert[0])
	check_y.pressed = (invert[1])

func _on_Check_X_toggled(value: bool) -> void:
	Settings.look_inversions[input_key][0] = value 
	Settings.reload_settings()

func _on_Check_Y_toggled(value: bool) -> void:
	Settings.look_inversions[input_key][1] = value 
	Settings.reload_settings()

