tool
extends Spatial
class_name Label3D

enum LocalBillboardMode {
	# localize the SpatialMaterial.BillboardMode for ease of use
	DISABLED = 0,
	ENABLED = 1,
	FIXED_Y = 2
}

enum LocalViewportUpdateMode {
	# localize Viewport.UpdateMode for ease of use
	# changing the update mode allows for situations where we want to set the text once and know it will never change. Use "once" in that case to ensure it gets refreshed exactly one time and never again.
	DISABLED = 0,
	ONCE = 1,
	WHEN_VISIBLE = 2,
	ALWAYS = 3
}

# exports
#	Label properties		<-- I'd love to be able to make sections for this to seperate groupings
export var text := "default text" setget _set_text
export (Color) var font_colour := Color.white setget _set_font_colour

#	Viewport properties
export var viewport_size := Vector2(300, 25) setget _set_viewport_size
# defaulting to use ONCE because a majority of situations would only need one update. I don't plan on making many situations where the text is updated.
export (LocalViewportUpdateMode) var viewport_update_mode := LocalViewportUpdateMode.ONCE setget _set_viewport_update_mode

#	Sprite properties
export (LocalBillboardMode) var sprite_billboard := LocalBillboardMode.ENABLED setget _set_sprite_billboard
export (float, 0.0, 1.0) var sprite_opacity := 1.0 setget _set_sprite_opacity
export var sprite_shaded := false setget _set_sprite_shaded
export var sprite_double_sided := true setget _set_sprite_double_sided
export var sprite_cast_shadow := true setget _set_sprite_cast_shadow
export var sprite_use_in_baked_light := false setget _set_sprite_use_in_baked_light

# child nodes
onready var viewport :Viewport= $Viewport
onready var label :Label= $Viewport/Label
onready var sprite :Sprite3D= $Sprite3D

func _refresh_label() -> void:
	if not label:
		label = $Viewport/Label
	label.text = text
	label.add_color_override("font_color", font_colour)

func _refresh_viewport() -> void:
	if not viewport:
		viewport = $Viewport
	viewport.size = viewport_size
	viewport.render_target_update_mode = viewport_update_mode

func _refresh_sprite() -> void:
	if not sprite:
		sprite = $Sprite3D
	sprite.billboard = sprite_billboard
	sprite.opacity = sprite_opacity
	sprite.shaded = sprite_shaded
	sprite.double_sided = sprite_double_sided
	sprite.cast_shadow = sprite_cast_shadow
	sprite.use_in_baked_light = sprite_use_in_baked_light


#
#	Setters
#

func _set_text(n_ : String):
	text = n_
	_refresh_label()
func _set_font_colour(n_ : Color):
	font_colour = n_
	_refresh_label()

func _set_viewport_size(n_ : Vector2):
	viewport_size = n_
	_refresh_viewport()
func _set_viewport_update_mode(n_ : int):
	viewport_update_mode = n_
	_refresh_viewport()

func _set_sprite_billboard(n_ : int):
	sprite_billboard = n_
	_refresh_sprite()
func _set_sprite_opacity(n_ : float):
	sprite_opacity = n_
	_refresh_sprite()
func _set_sprite_shaded(n_ : bool):
	sprite_shaded = n_
	_refresh_sprite()
func _set_sprite_double_sided(n_ : bool):
	sprite_double_sided = n_
	_refresh_sprite()
func _set_sprite_cast_shadow(n_ : bool):
	sprite_cast_shadow = n_
	_refresh_sprite()
func _set_sprite_use_in_baked_light(n_ : bool):
	sprite_use_in_baked_light = n_
	_refresh_sprite()
