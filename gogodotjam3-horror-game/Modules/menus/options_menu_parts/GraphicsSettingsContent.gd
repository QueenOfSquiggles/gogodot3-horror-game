extends HSplitContainer

onready var fullscreen : CheckBox = $VBoxContainer/PanelContainer2/HBoxContainer/CheckFullscreen
onready var retro_filter : CheckBox = $VBoxContainer/PanelContainer2/HBoxContainer/CheckRetroFilter
onready var msaa_filter : OptionButton = $VBoxContainer/HBoxContainer2/OptionMSAAFilter
onready var glow : CheckBox = $VBoxContainer/PanelContainer/VBoxContainer/CheckGlow
onready var ssao : CheckBox = $VBoxContainer/PanelContainer/VBoxContainer/CheckSSAO
onready var ssr : CheckBox = $VBoxContainer/PanelContainer/VBoxContainer/CheckSSR

onready var demo_viewport := $AspectRatioContainer/ViewportContainer/Viewport

func _ready() -> void:
	demo_viewport.set_physics_process(false)
	demo_viewport.set_process(false)
	# preset options
	
	# msaa filters
	msaa_filter.add_item("options.gfx.msaa.disabled", Viewport.MSAA_DISABLED)
	msaa_filter.add_item("MSAA 2x", Viewport.MSAA_2X)
	msaa_filter.add_item("MSAA 4x",Viewport.MSAA_4X)
	msaa_filter.add_item("MSAA 8x", Viewport.MSAA_8X)
	update_options_from_settings()

func update_options_from_settings() -> void:
	fullscreen.pressed = Settings.fullscreen
	retro_filter.pressed = Settings.use_retro_filter
	msaa_filter.selected = Settings.viewport_msaa
	glow.pressed = Settings.world_environment["glow_enabled"]
	ssao.pressed = Settings.world_environment["ssao_enabled"]
	ssr.pressed = Settings.world_environment["ss_reflections_enabled"]

func _on_BtnApply_pressed() -> void:
	Settings.fullscreen = fullscreen.pressed
	Settings.use_retro_filter = retro_filter.pressed
	Settings.viewport_msaa = msaa_filter.get_item_id(msaa_filter.selected)
	Settings.world_environment["glow_enabled"] = glow.pressed
	Settings.world_environment["ssao_enabled"] = ssao.pressed
	Settings.world_environment["ss_reflections_enabled"] = ssr.pressed

	Settings.reload_settings()
	update_options_from_settings()
	demo_viewport.render_target_update_mode = Viewport.UPDATE_ONCE

func _on_ViewportContainer_item_rect_changed() -> void:
	if demo_viewport:
		demo_viewport.render_target_update_mode = Viewport.UPDATE_ONCE
