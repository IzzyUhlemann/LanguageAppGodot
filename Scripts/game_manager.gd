# # # # # # # # # # #
# Game Manager Node
# 

extends Node

var curWord:String = ""
var curLetters:String = ""
const alphabet:String = "abcdefghijklmnopqrstuvwxyz"
var spanishList:Array = ["verde", "blanco", "rojo", "naranja", "amarillo", "azul", "marrón", "gris", "morado", "rosado"]
var englishList:Array = ["green", "white", "red", "orange", "yellow", "blue", "brown", "grey", "purple", "pink"]

@onready var piano_display: Node2D = $MIDIController/CanvasLayer/PianoDisplay
@onready var input_label: Label = $TestLabels/InputLabel
@onready var word_label: Node2D = $TestLabels/WordLabel


func _ready():
	display_new_word()


func display_new_word():
	var rng = RandomNumberGenerator.new()
	var scale = []
	var scaleList = [
		[48, 50, 52, 53, 55, 57, 59, 60, 62, 64, 65, 67, 69, 71, 72], # C Major
		[48, 50, 52, 54, 55, 57, 59, 60, 62, 64, 66, 67, 69, 71, 72], # G Major
		[48, 50, 52, 54, 55, 57, 59, 61, 62, 64, 66, 67, 69, 71, 72], # D Major
		[49, 50, 52, 54, 56, 57, 59, 61, 62, 64, 66, 68, 69, 71, 72], # A Major
		[49, 51, 52, 54, 56, 57, 59, 61, 63, 64, 66, 68, 69, 71, 72] # E Major
	]
	
	# Set scale from list of scales
	scale = scaleList[rng.randi_range(0, scaleList.size()-1)]
	
	# Choose spanish word to test
	var index = rng.randi_range(0, spanishList.size()-1)
	curWord = spanishList[index]
	
	# Set label text
	word_label.spanish_label.text = spanishList[index]
	word_label.english_label.text = englishList[index]
	word_label.get_node("AnimationPlayer").play("slide_in")
	
	# Determine range where letters may be placed on piano display
	var displayRange = scale.size() - curWord.length()
	var pianoPos = rng.randf_range(0, displayRange)
	
	# Sets key labels on piano preview
	for i in curWord.length():
		piano_display.set_key_label(scale[i+pianoPos], curWord[i])
		
	# Add random letters to set of random piano keys
	var bSetKey = rng.randi_range(0, 1)
	var randLetter = rng.randi_range(0, alphabet.length()-1)
	for i in scale:
		bSetKey = round(rng.randf_range(0, 1))
		if (bSetKey == 1 && piano_display.get_key_label(i) == ""):
			piano_display.set_key_label(i, alphabet[randLetter])
			randLetter = rng.randi_range(0, alphabet.length()-1)


func play_note(pitch):
	var newLetter = piano_display.get_key_label(pitch)
	
	# Adds note currently being played to buffer as long as there's room
	if (input_label.text.length() < curWord.length()):
		curLetters += newLetter
		input_label.text += newLetter
	
	# If we have as many letters as there are in the word or more
	if curLetters.length() >= curWord.length():
		if curLetters == curWord: # And the arrays both match
			word_matched()		# Call word_matched()
		else:				  # Otherwise, reset
			curLetters = ""
			input_label.get_node("AnimationPlayer").play("label_mismatch")


func word_matched():
	# Reset current input string
	curLetters = ""
	
	# Reset labels on piano
	piano_display.reset_labels()
	
	# Play animation which starts a timer before resetting input field and calling display_new_word()
	word_label.get_node("AnimationPlayer").play("slide_out")
	input_label.get_node("AnimationPlayer").play("label_match")
