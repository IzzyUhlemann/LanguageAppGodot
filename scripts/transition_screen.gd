extends CanvasLayer

signal transitioned

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade_out():
	animation_player.play("fade_to_white")


func fade_in():
	animation_player.play("fade_to_normal")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_to_white":
		emit_signal("transitioned")
