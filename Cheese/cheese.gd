class_name Cheese
extends Area2D

var gett = true
var level : int = 1

func _ready() -> void:
	modulate.a = 0
	get_tree().create_tween().tween_property(self,"modulate:a",1,1)
	var r = 1.2 - level * 0.2
	var g = 1.1 - level * 0.1
	if r < 0: r = 0
	if g < 0: g = 0
	$Sprite.modulate = Color(r,g,1)


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player and gett:
		gett = false
		area.get_parent().add_cheese(level)
		var fade = get_tree().create_tween()
		fade.tween_property(self,"modulate:a",0,0.25)
		await fade.finished
		queue_free()
