class_name Main
extends Node2D

const cam_speed = 5

@onready var camera : Camera2D = $Camera
@onready var player : Player = $Player

func _physics_process(delta: float) -> void:
	set_camera(delta)


func set_camera(delta: float) -> void:
	camera.global_position = camera.global_position.lerp(player.global_position, cam_speed*delta)
