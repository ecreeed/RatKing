class_name Loot
extends Area2D

var gett = true
var item_type : String = "grenade"

@onready var anim : AnimatedSprite2D = $Sprite

func _ready() -> void:
	anim.play(item_type)
	modulate.a = 0
	get_tree().create_tween().tween_property(self,"modulate:a",1,1)


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player and gett:
		if area.get_parent().held_item == "":
			gett = false
			area.get_parent().pickup(item_type)
			var fade = get_tree().create_tween()
			fade.tween_property(self,"modulate:a",0,0.25)
			await fade.finished
			queue_free()
