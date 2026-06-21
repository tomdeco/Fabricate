extends MainLoop


var time_elapsed = 0

func _initialize():
	print("Initialized:")
	print("  Starting time: %s" % str(time_elapsed))

func _process(delta):
	time_elapsed += delta
	# Return true to end the main loop.
	return Input.get_mouse_button_mask() != 0 || Input.is_key_pressed(KEY_ESCAPE)

func _finalize():
	print("Finalized:")
	print("  End time: %s" % str(time_elapsed))
