extends Leaf

export (String) var input_name := "input_toggle_flashlight"
export (NodePath) var light_toggle_path : NodePath
export (bool) var starting_state := true

onready var light : Light = get_node(light_toggle_path)
onready var default_energy :float = (light as Light).light_energy

onready var toggled := not starting_state

func _ready():
	_do_toggle()
	
func tick(_actor : Node, bb : Blackboard) -> int:
	var toggle := bb.get(input_name) as bool
	if toggle:
		_do_toggle()
	return SUCCESS

func _do_toggle() -> void:
	toggled = not toggled
	light.light_energy = default_energy if toggled else 0.0
