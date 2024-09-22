extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label
@export var pitch:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func hide_label():
	label.text = ""


func key_on():
	animated_sprite.play("on")
	

func key_off():
	animated_sprite.play("off")
