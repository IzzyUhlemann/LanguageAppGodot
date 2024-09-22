extends Control

@onready var game_manager: Node = %GameManager
@onready var piano_display: Node2D = $CanvasLayer/PianoDisplay

const MINPITCH:int = 48
const MAXPITCH:int = 72


# Called when the node enters the scene tree for the first time.
func _ready():
	# Start listening for midi input
	print("Input is being opened")
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())

func _input(event):
	if event is InputEventMIDI:
		if event.channel == 0:
			# If the key being played is within range for the piano display
			if event.pitch >= MINPITCH && event.pitch <= MAXPITCH:
				# Fire play_note() method on piano display (animates key)
				piano_display.play_note(event.pitch, event.velocity)
				if (event.velocity > 0):
					game_manager.play_note(event.pitch)


func close_inputs():
	# Stop listening for midi input and free controller
	print("Input is being closed")
	OS.close_midi_inputs()
	queue_free()
