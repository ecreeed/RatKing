class_name Explosion
extends Area2D




func _on_animation_animation_finished() -> void:
	queue_free()



func _on_body_entered(_body: Node2D) -> void:
	for bod in get_overlapping_bodies():
		if bod is Cat:
			bod.take_dmg(10)
