extends Node2D

@onready var letter_label: Label = $letter_label
@onready var primary_label: Label = $primary_label
@onready var secondary_label: Label = $secondary_label
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


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


func set_image(input):
	if sprite_2d.frame != null:
		sprite_2d.frame = input


func display_word():
	primary_label.show()
	secondary_label.show()
	sprite_2d.show()
	letter_label.hide()


func hide_word():
	primary_label.hide()
	secondary_label.hide()
	sprite_2d.hide()
	letter_label.show()
