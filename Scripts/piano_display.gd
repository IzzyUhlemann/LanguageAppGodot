extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_labels()


func set_key_label(note, letter):
	# Sets key label, as long as pressed key is not null
	var key = get_node("Key" + str(note))
	if key.label.text != null:
		key.label.text = letter


func get_key_label(note):
	# Gets key label, as long as pressed key is not null
	var key = get_node("Key" + str(note))
	if key.label.text != null:
		return key.label.text
	else:
		return null


func play_note(note, velocity):
	# Get number associated with midi note and play correct key
	var key = get_node("Key" + str(note))
	if velocity > 0:
		key.key_on()
	else:
		key.key_off()


func reset_labels():
	for child in self.get_children():
		child.hide_label() # Note: currently tells EVERY child of root to call this function!


func is_key_held(note):
	return get_node("Key" + str(note)).bHeld
