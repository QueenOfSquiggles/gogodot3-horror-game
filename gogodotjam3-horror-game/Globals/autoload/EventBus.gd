extends Node


signal final_cutscene

func trigger_event(event_name : String, args = null) -> void:
	if not self.has_signal(event_name):
		# an event was attempted to be triggered, but it doesn't exist or was misspelled.
		push_error("Failed to trigger event ['%s'], not found on event bus!")
		return
	if args:
		# trigger an event with arguments
		emit_signal(event_name, args)
	else:
		# trigger an event with no args
		emit_signal(event_name)
