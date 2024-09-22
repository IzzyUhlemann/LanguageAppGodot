extends Node

enum Difficulty {
	EASY,
	HARD,
}

enum LabelType {
	ALPHABET,
	SYMBOL,
	WORD,
}

const TOTAL_KEYS = 24

var prev_key:int
var next_key:int
var curWord:int = 0
var alphabetStart:int = 0

@export_file var level_path
@export_file var language_path = "res://language/words.txt"
@export var label_spacing:int = 350
@export var label_height:int = -140
@export var label_type:LabelType
@export var exercise_difficulty:Difficulty

@onready var piano_display: Node2D = $MIDIController/CanvasLayer/PianoDisplay
@onready var midi_controller: Control = $MIDIController
@onready var transition_screen: CanvasLayer = $TransitionScreen
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var camera: Camera2D = $Camera2D
@onready var score: Node2D = $MIDIController/CanvasLayer/Score
@onready var list = Array([])


func _ready():
	# Load spanish and english words, generate labels
	transition_screen.fade_in()
	start_music()
	list = load_file_string(language_path)
	generate_labels()
	if exercise_difficulty == Difficulty.EASY:
		set_key_labels_arrows()
	elif exercise_difficulty == Difficulty.HARD:
		set_key_labels_fill()


func _input(_ev):
	if Input.is_key_pressed(KEY_LEFT):
		play_note(prev_key)
	elif Input.is_key_pressed(KEY_RIGHT):
		play_note(next_key)
	
	
func load_file_string(filename):
	var result = []
	var f = FileAccess.open(filename, FileAccess.READ)
	while not f.eof_reached():
		var line = f.get_csv_line()
		result.append(line)
	f.close()
	return result


func set_key_labels_arrows():
	# TODO: add functionality to set keys differently depending on difficulty
	# Really need to prevent using multiple managers for same exercise
	prev_key = 61
	next_key = 63
	
	if piano_display != null:
		piano_display.set_key_label(prev_key, "<")
		piano_display.set_key_label(next_key, ">")


func set_key_labels_fill():
	# NOTE: Starts at random set of letters that fit on keys. Currently needs to account for empty entries
	prev_key = 48
	next_key = 72
	alphabetStart = RandomNumberGenerator.new().randi_range(0, list.size()-TOTAL_KEYS-2)
	var counter:int = alphabetStart
	
	if piano_display != null:
		piano_display.set_key_label(prev_key, "<")
		piano_display.set_key_label(next_key, ">")

	for i:int in range(prev_key+1, next_key):
		counter += 1
		piano_display.set_key_label(i, list[counter][0][0])


func generate_labels():
	var label_scene = preload("res://Scenes/alphabet_label.tscn")
	var xPos:int = 0
	
	# Iterate through each letter in given alphabet and generate labels for each
	for i in list.size() - 1:
		var newLabel = label_scene.instantiate()
		newLabel.label_type = label_type
		newLabel.name = "Label_" + str(i)
		newLabel.position.x = xPos
		newLabel.position.y = label_height
		add_child(newLabel)
		set_label_properties(newLabel, i)
		xPos += label_spacing


func set_label_properties(newLabel, i):
	newLabel.set_letter_label(list[i][0].substr(0,1))
	newLabel.set_primary_label(list[i][0])
	newLabel.set_secondary_label(list[i][1])
	newLabel.set_image(list, list[i][2])


func scroll_letters_forward():
	# Scroll to next letter position and display its associated word
	var newLabel = get_node("Label_" + str(curWord+1))
	var oldLabel = get_node("Label_" + str(curWord))
	
	if newLabel != null && oldLabel != null:
		newLabel.display_word()
		oldLabel.hide_word()
		camera.position.x = newLabel.position.x


func scroll_letters_backward():
	# Scroll to previous letter position and display its associated word
	var newLabel = get_node("Label_" + str(curWord-1))
	var oldLabel = get_node("Label_" + str(curWord))
	
	if newLabel != null && oldLabel != null:
		newLabel.display_word()
		oldLabel.hide_word()
		camera.position.x = newLabel.position.x


func scroll_to_letter():
	# Scroll to previous letter position and display its associated word
	
	for i in list.size()-1:
		var foundLabel = get_node("Label_" + str(i))
		if i == curWord:
			foundLabel.display_word()
			camera.position.x = foundLabel.position.x
		else:
			foundLabel.hide_word()


func transition_scenes():
	transition_screen.fade_out()
	var tween = get_tree().create_tween()
	tween.tween_property(audio_player, "volume_db", -80, 1)
	tween.tween_callback(audio_player.stop)


func _on_transition_screen_transitioned() -> void:
	print("This is getting called")
	if level_path != null:
		midi_controller.close_inputs()
		get_tree().change_scene_to_file(level_path)


func start_music():
	audio_player.volume_db = -80
	audio_player.play()
	var tween = get_tree().create_tween()
	tween.tween_property(audio_player, "volume_db", -20, 1)


func play_word_audio():
	# Plays audio in Spanish voice if installed, otherwise defaults to english
	var voices = DisplayServer.tts_get_voices_for_language("es")
	if voices.is_empty():
		voices = DisplayServer.tts_get_voices_for_language("en")
	var voice_id = voices[0]
	DisplayServer.tts_speak(list[curWord][0], voice_id, 70, 100.0, 1.3, 10, false)


func play_note(pitch):
	# Ensure letter exists, check which note was pressed, and scroll if appropriate
	if pitch == prev_key && curWord > 0: # C#
		scroll_letters_backward()
		curWord -= 1
	# NOTE: for some reason Godot keeps adding an empty entry to the list, so the -2 accounts for this
	elif pitch == next_key && curWord < list.size()-2: # D#
		scroll_letters_forward()
		update_score()
		#score.current_score.text = str(score.current_score)
		curWord += 1
	elif exercise_difficulty == Difficulty.HARD && pitch >= 49 && pitch <= 71:
		curWord = pitch+alphabetStart - 48
		scroll_to_letter()
	# NOTE: for some reason Godot keeps adding an empty entry to the list, so the -2 accounts for this
	elif curWord <= 0 || curWord >= list.size()-2:
		transition_scenes()
		
	# Play audio associated with word
	play_word_audio()


func update_score():
	score.current_score += 10
	score.current_label.text = str(score.current_score)
