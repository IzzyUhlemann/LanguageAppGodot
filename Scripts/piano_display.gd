extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_labels()


func set_key_label(note, letter):
	# note: REALLY should do some validation checking here
	var key = get_node("Key" + str(note))
	if key.label.text != null:
		key.label.text = letter


func get_key_label(note):
	# Again, dubious validation
	var key = get_node("Key" + str(note))
	if key.label.text != null:
		return key.label.text
	else:
		return null


func play_note(note):
	# Get number associated with midi note and play correct key
	get_node("Key" + str(note)).key_pressed()


func reset_labels():
	for child in self.get_children():
		child.hide_label() # Note: currently tells EVERY child of root to call this function!


func is_key_held(note):
	return get_node("Key" + str(note)).bHeld
