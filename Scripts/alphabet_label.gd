extends Node2D

enum LabelType {
	ALPHABET,
	SYMBOL,
	WORD,
}

@export var label_type: LabelType
@onready var letter_label: Label = $letter_label
@onready var primary_label: Label = $primary_label
@onready var secondary_label: Label = $secondary_label
@onready var sprite: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_word()


func set_letter_label(input):
	if letter_label != null:
		letter_label.text = input
	

func set_primary_label(input):
	if primary_label != null:
		primary_label.text = input
		
		
func set_secondary_label(input):
	if secondary_label != null:
		secondary_label.text = input


func set_image(list,input):
	for i in list.size() - 1:
		if(list[i][2] == input):
			var filepath = "res://assets/images/icons/alphabet/" + str(list[i][2]) + ".png" 
			print(filepath)
			var new_texture = load(filepath)
			sprite.set_texture(new_texture)


func display_word():
	if label_type == LabelType.ALPHABET:
		primary_label.show()
		secondary_label.show()
		sprite.show()
		letter_label.hide()
	elif label_type == LabelType.SYMBOL:
		primary_label.show()
		secondary_label.show()
		sprite.show()
		letter_label.hide()
	elif label_type == LabelType.WORD:
		primary_label.show()
		secondary_label.show()
		sprite.show()
		letter_label.hide()


func hide_word():
	if label_type == LabelType.ALPHABET:
		primary_label.hide()
		secondary_label.hide()
		sprite.hide()
		letter_label.show()
	elif label_type == LabelType.SYMBOL:
		primary_label.hide()
		secondary_label.hide()
		sprite.show()
		letter_label.hide()
	elif label_type == LabelType.WORD:
		primary_label.show()
		secondary_label.hide()
		sprite.hide()
		letter_label.hide()
