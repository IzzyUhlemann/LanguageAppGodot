extends Node2D

@onready var highest_label: Label = $HighestLabel
@onready var current_label: Label = $ScoreLabel

	
var current_score = 0 : 
	set (x) : current_score = x


func _ready():
	if highest_label != null:
		highest_label.text = str(SaveLoad.highest_record)
	if current_label != null:
		current_label.text = str(current_score)
	

func _on_save_score_pressed():
	if current_score > SaveLoad.highest_record :
		SaveLoad.highest_record = current_score
		highest_label.text = str(current_score)
	SaveLoad.save_score()
