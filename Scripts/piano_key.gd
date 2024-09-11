extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label

var bHeld = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func hide_label():
	label.text = ""


func key_pressed():
	# Pressing and releasing note both will send a signal
	# So we use a bool to determine whether to press or release key
	if bHeld == false:
		animated_sprite.play("on")
		bHeld = true
	elif bHeld == true:
		animated_sprite.play("off")
		bHeld = false
