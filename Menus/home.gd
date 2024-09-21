class_name Home
extends CanvasLayer

var sys : System

func _ready() -> void:
	get_tree().paused = false


func _on_start_pressed() -> void:
	sys.change_scene("res://Main/main.tscn")



func _on_quit_pressed() -> void:
	get_tree().quit()
