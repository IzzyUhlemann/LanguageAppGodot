# # # # # # # # # # #
# Game Manager Node #
# # # # # # # # # # #

extends Node

const LABEL_SPACING:int = 350
const LABEL_HEIGHT:int = -140
const PREV_KEY:int = 61
const NEXT_KEY:int = 63

var spanishList:Array = []
var englishList:Array = []
var curWord:int = -1
@export var usingSpanish:bool = true

@onready var piano_display: Node2D = $MIDIController/CanvasLayer/PianoDisplay
@onready var camera: Camera2D = $Camera2D
@onready var score: Node2D = $MIDIController/CanvasLayer/Score


func _ready():
	# Load spanish and english words, generate labels
	spanishList = load_file_string("res://Spanish.txt")
	englishList = load_file_string("res://English.txt")
	generate_labels(usingSpanish)
	set_key_labels()

	
func load_file_string(filename):
	var result = []
	var f = FileAccess.open(filename, FileAccess.READ)
	while not f.eof_reached():
		var line = f.get_line()
		result.append(line)
	f.close()
	return result
	

func generate_labels(usingSpanish:bool):
	var alphabet_label_scene = preload("res://Scenes/alphabet_label.tscn")
	var xPos:int = LABEL_SPACING
	
	# Iterate through each letter in given alphabet and generate labels for each
	for i in spanishList.size():
		var newLabel = alphabet_label_scene.instantiate()
		newLabel.name = "Label_" + str(i)
		newLabel.position.x = xPos
		newLabel.position.y = LABEL_HEIGHT
		add_child(newLabel)
		xPos += LABEL_SPACING
	
	# NOTE: This is in a separate loop to ensure properties aren't null when being set
	for i in spanishList.size():
		var foundLabel = get_node("Label_" + str(i))
		foundLabel.set_letter_label(spanishList[i][0])
		if usingSpanish:
			foundLabel.set_primary_label(spanishList[i])
			foundLabel.set_secondary_label(englishList[i])
		else:
			foundLabel.set_primary_label(englishList[i])
		foundLabel.set_image(i)


func set_key_labels():
	if piano_display != null:
		piano_display.set_key_label(PREV_KEY, "<")
		piano_display.set_key_label(NEXT_KEY, ">")


func scroll_letters_forward():
	# Scroll to next letter position and display its associated word
	for i in spanishList.size():
		var foundLabel = get_node("Label_" + str(i))
		if i == curWord+1:
			foundLabel.display_word()
			camera.position.x = foundLabel.position.x
		else:
			foundLabel.hide_word()


func scroll_letters_backward():
	# Scroll to previous letter position and display its associated word
	for i in spanishList.size():
		var foundLabel = get_node("Label_" + str(i))
		if i == curWord-1:
			foundLabel.display_word()
			camera.position.x = foundLabel.position.x
		else:
			foundLabel.hide_word()


func play_note(pitch):
	# Ensure letter exists, check which note was pressed, and scroll if appropriate
	if curWord > 0 && pitch == PREV_KEY: # C#
		scroll_letters_backward()
		curWord -= 1
	elif curWord < spanishList.size()-1 && pitch == NEXT_KEY: # D#
		scroll_letters_forward()
		update_score()	
		#score.current_score.text = str(score.current_score)
		curWord += 1


func update_score():
	score.current_score += 10
	print(score.current_score)
	score.current_label.text = str(score.current_score)
