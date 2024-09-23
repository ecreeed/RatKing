class_name Explosion
extends Area2D



func _on_animation_animation_finished() -> void:
	visible = false



func _on_body_entered(_body: Node2D) -> void:
	for bod in get_overlapping_bodies():
		if bod is Cat:
			bod.take_dmg(10)



func _on_audio_finished() -> void:
	queue_free()
