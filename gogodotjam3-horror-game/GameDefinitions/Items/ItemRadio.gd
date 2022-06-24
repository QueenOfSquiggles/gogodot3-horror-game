extends PickupItemBase

var is_on := false

export (SpatialMaterial) var led_off_material : SpatialMaterial
export (SpatialMaterial) var led_on_material : SpatialMaterial

onready var led_mesh := $MeshInstance

func _ready() -> void:
	_update_state()

func use_item(_source : Node) -> void:
	is_on = not is_on
	_update_state()

func _update_state() -> void:
	var material := led_off_material
	if is_on:
		material = led_on_material
	led_mesh.material_override = material
