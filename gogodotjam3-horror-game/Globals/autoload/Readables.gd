extends CanvasLayer

const readable_popup_scene := preload("res://Globals/readables/ReadableTextPopup.tscn")
const theme := preload("res://Modules/menus/theming/basic_theme.tres")
signal popup_closed

var popup : AcceptDialog = null

func _ready():
	self.set_process_input(true)
	self.layer = 25
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func display_readable(title : String, text : String, screen_ratio : float = 0.8) -> void:
	popup = readable_popup_scene.instance()
	popup.window_title = tr(title) # I want to use translation keys here for future translation options
	popup.dialog_text = tr(text)
	popup.theme = theme
	add_child(popup)
	
	var _clr := popup.connect("popup_hide", self, "_readable_closed")
	
	popup.popup_centered_clamped(popup.rect_size, screen_ratio)
	Globals.set_paused(true)
	Globals.unlock_mouse()

func _readable_closed() -> void:
	yield(VisualServer, "frame_post_draw")
	popup.queue_free()
	popup = null
	Globals.set_paused(false)
	Globals.lock_mouse()
	emit_signal("popup_closed")

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel") and is_instance_valid(popup):
		popup.hide()
