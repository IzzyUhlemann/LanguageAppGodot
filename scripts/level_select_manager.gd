extends Node

@onready var piano_display: Node2D = $MIDIController/CanvasLayer/PianoDisplay
@onready var midi_controller: Control = $MIDIController
@onready var level_select_screen: Control = $LevelSelectScreen
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var transition_screen: CanvasLayer = $TransitionScreen

const PREV_KEY:int = 61
const NEXT_KEY:int = 63
const SELECT_KEY:int = 62

func _ready():
	# Set labels for relevant keys
	transition_screen.fade_in()
	start_music()
	set_key_labels()


func _input(_ev):
	if Input.is_key_pressed(KEY_RIGHT):
		play_note(NEXT_KEY)
	elif Input.is_key_pressed(KEY_LEFT):
		play_note(PREV_KEY)
	elif Input.is_key_pressed(KEY_DOWN):
		play_note(SELECT_KEY)


func play_note(pitch):
	if pitch == PREV_KEY:
		level_select_screen.select_prev_level()
	elif pitch == NEXT_KEY:
		level_select_screen.select_next_level()
	elif pitch == SELECT_KEY:
		transition_scenes()


func start_music():
	audio_player.volume_db = -80
	audio_player.play()
	var tween = get_tree().create_tween()
	tween.tween_property(audio_player, "volume_db", 0, 1)


func set_key_labels():
	if piano_display != null:
		piano_display.set_key_label(PREV_KEY, "<")
		piano_display.set_key_label(NEXT_KEY, ">")
		piano_display.set_key_label(SELECT_KEY, "!")


func transition_scenes():
	transition_screen.fade_out()
	var tween = get_tree().create_tween()
	tween.tween_property(audio_player, "volume_db", -80, 1)
	tween.tween_callback(audio_player.stop)
	tween.tween_callback(midi_controller.close_inputs)


func _on_transition_screen_transitioned() -> void:
	pass # Replace with function body.
	level_select_screen.load_new_level()
