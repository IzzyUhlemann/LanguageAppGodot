extends Control


@onready var game_manager: Node = %GameManager
@onready var piano_display: Node2D = $CanvasLayer/PianoDisplay
var MINPITCH = 48
var MAXPITCH = 72


# Called when the node enters the scene tree for the first time.
func _ready():
	# Start listening for midi input
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())

func _input(event):
	if event is InputEventMIDI:
		if event.channel == 0:
			# Prints pitch to console for reference
			printt("pitch", event.pitch)
			# If the key being played is within range for the piano display
			if event.pitch >= MINPITCH && event.pitch <= MAXPITCH:
				# Fire play_note() method on piano display (animates key)
				piano_display.play_note(event.pitch)
				if (piano_display.is_key_held(event.pitch)):
					game_manager.play_note(event.pitch)
