extends Node2D

@onready var animation_player: AnimationPlayer = $CircleTimer/AnimationPlayer
@onready var circle_timer: Sprite2D = $CircleTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func handle_timer(bDir):
	var curScale = circle_timer.scale
	var tween = create_tween()
	tween.tween_interval(2)
	if (bDir):
		tween.tween_property(circle_timer, "scale", Vector2(), 5)
	else:
		tween.tween_property(circle_timer, "scale", Vector2(1, 1), 1)
