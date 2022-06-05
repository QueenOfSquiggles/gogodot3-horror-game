extends HSplitContainer

export (PackedScene) var demo_world_packed : PackedScene

onready var preset : OptionButton = $VBoxContainer/HBoxContainer3/OptionPresets
onready var fullscreen : CheckBox = $VBoxContainer/HBoxContainer/CheckFullscreen
onready var retro_filter : CheckBox = $VBoxContainer/HBoxContainer/CheckRetroFilter
onready var msaa_filter : OptionButton = $VBoxContainer/HBoxContainer2/OptionMSAAFilter
onready var glow : CheckBox = $VBoxContainer/PanelContainer/VBoxContainer/CheckGlow
onready var ssao : CheckBox = $VBoxContainer/PanelContainer/VBoxContainer/CheckSSAO
onready var ssr : CheckBox = $VBoxContainer/PanelContainer/VBoxContainer/CheckSSR


onready var demo_world_root := $"AspectRatioContainer"

func _ready() -> void:
	# preset options
	preset.add_item("Custom", 999)
	preset.add_item("Low", GraphicsPresets.ID_PRESET_LOW)
	preset.add_item("Medium", GraphicsPresets.ID_PRESET_MEDIUM)
	preset.add_item("High", GraphicsPresets.ID_PRESET_HIGH)
	
	# msaa filters
	msaa_filter.add_item("MSAA Disabled", Viewport.MSAA_DISABLED)
	msaa_filter.add_item("MSAA 2x", Viewport.MSAA_2X)
	msaa_filter.add_item("MSAA 4x",Viewport.MSAA_4X)
	msaa_filter.add_item("MSAA 8x", Viewport.MSAA_8X)
	msaa_filter.add_item("MSAA 16x", Viewport.MSAA_16X)
	update_options_from_settings()

func update_options_from_settings() -> void:
	fullscreen.pressed = Settings.fullscreen
	retro_filter.pressed = Settings.use_retro_filter
	msaa_filter.selected = Settings.viewport_msaa
	glow.pressed = Settings.world_environment["glow_enabled"]
	ssao.pressed = Settings.world_environment["ssao_enabled"]
	ssr.pressed = Settings.world_environment["ss_reflections_enabled"]

func _on_BtnApply_pressed() -> void:
	var preset_id :int= preset.get_item_id(preset.selected)
	if preset_id == 999:
		print("Using custom graphics settings")
		Settings.fullscreen = fullscreen.pressed
		Settings.use_retro_filter = retro_filter.pressed
		Settings.viewport_msaa = msaa_filter.get_item_id(msaa_filter.selected)
		Settings.world_environment["glow_enabled"] = glow.pressed
		Settings.world_environment["ssao_enabled"] = ssao.pressed
		Settings.world_environment["ss_reflections_enabled"] = ssr.pressed
	else:
		print("Using graphics preset : ", preset_id)
		GraphicsPresets.apply_preset_id(preset_id)
	Settings.reload_settings()
	update_options_from_settings()

func _handle_visibility() -> void:
	if not demo_world_packed:
		return
	if get_parent().visible:
		if demo_world_root.get_child_count() <= 0:
			var inst : Control = demo_world_packed.instance()
			if inst:
				demo_world_root.add_child(inst)
	else:
		for c in demo_world_root.get_children():
			c.queue_free()
