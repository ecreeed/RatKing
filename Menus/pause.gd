class_name PauseMenu
extends CanvasLayer

var battle : Main




func _on_resume_pressed() -> void:
	battle.pause(false)


func _on_quit_pressed() -> void:
	battle.sys.change_scene("res://Menus/home.tscn")
