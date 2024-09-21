class_name System
extends Node2D


var current_scene : Node

func _ready() -> void:
	change_scene("res://Menus/home.tscn")


func change_scene(address: String) -> void:
	var new_scene = load(address).instantiate()
	new_scene.sys = self
	if current_scene:
		current_scene.queue_free()
	current_scene = new_scene
	add_child(new_scene)
