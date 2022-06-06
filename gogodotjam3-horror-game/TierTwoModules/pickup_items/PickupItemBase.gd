extends RigidBody
class_name PickupItemBase
"""
Base class for all pickup items. 

Extending this will allow for interesting functionality for different objects.
"""

enum RigidModeStart {
	RIGID_UNTIL_PICKUP,
	START_STATIC,
}

enum StaticStyle {
	ONLY_AFTER_DROPPED,
	ALWAYS_ON_SLEEP,
	NEVER
}

export (RigidModeStart) var rigid_mode_start := RigidModeStart.RIGID_UNTIL_PICKUP
export (StaticStyle) var static_mode_style := StaticStyle.ONLY_AFTER_DROPPED
export (bool) var keep_rotation := true
export (String) var sfx_impact := "impact"
export (String) var sfx_pickup := "pickup"
export (String) var sfx_drop := "drop"

export (String) var item_name := "item.generic.name"
export (String) var item_description := "item.generic.description"

onready var original_parent := get_parent()
onready var original_collision_layer := self.collision_layer
onready var original_collision_mask := self.collision_mask
onready var audio_lib := $PickupItemsAudioLib

var is_being_held := false

var has_been_dropped_before := false

func _ready() -> void:
	match rigid_mode_start:
		RigidModeStart.RIGID_UNTIL_PICKUP:
			self.mode = RigidBody.MODE_RIGID
		RigidModeStart.START_STATIC:
			self.mode = RigidBody.MODE_STATIC
	if not audio_lib:
		push_warning("PickupItem [%s] does not have an AudioLib3D set" % self.name)

func interact(source : Node) -> void:
	if source.has_method("set_held_item"):
		source.set_held_item(null if is_being_held else self)

func use_item(_source : Node) -> void:
	pass

func pickup_item(_source : Node) -> void:
	is_being_held = true
	mode = RigidBody.MODE_STATIC
	transform = Transform.IDENTITY # reset position to ensure no weird reactions.
	collision_layer = 0
	collision_mask = 0
	if audio_lib:
		audio_lib.play(sfx_pickup)

func remove_item(_player : Node) -> void:
	is_being_held = false
	self.mode = RigidBody.MODE_RIGID
	self.collision_layer = original_collision_layer
	self.collision_mask = original_collision_mask
	has_been_dropped_before = true
	if audio_lib:
		audio_lib.play(sfx_drop)
	

func _on_sleeping_state_changed() -> void:
	if self.sleeping:
		match(static_mode_style):
			StaticStyle.ALWAYS_ON_SLEEP:
				self.mode = RigidBody.MODE_STATIC
			StaticStyle.ONLY_AFTER_DROPPED:
				if has_been_dropped_before:
					self.mode = RigidBody.MODE_STATIC

func _on_self_body_entered(_body: Node) -> void:
	# called when any collision is detected
	if audio_lib:
		audio_lib.play(sfx_impact)

func save_data() -> Dictionary:
	var data := {}
	data["has_been_dropped"] = has_been_dropped_before
	data["held"] = is_being_held
	return data

func load_save_data(data : Dictionary) -> void:
	has_been_dropped_before = data["has_been_dropped"] as bool
	is_being_held = data["held"] as bool
	if is_being_held:
		pickup_item(null) # doesn't actually use the player instance
		original_parent = get_tree().current_scene # fail-safe


func _on_InteractableArea_on_interact(source) -> void:
	self.interact(source)
