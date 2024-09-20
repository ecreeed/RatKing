class_name Gun
extends AnimatedSprite2D

@onready var lever : Sprite2D = $Lever
@onready var machine : StateChart = $StateChart

var player : Player
var rl_pos = 70

var ammo_cap : int = 10
var ammo : int = 5
var reload_amount : int = 1
var reload_speed : float = 0.5


func shoot() -> void:
	if ammo > 0:
		machine.send_event("shoot")
	else:
		do_reload()


func flip(action: bool) -> void:
	flip_v = action
	lever.flip_v = action
	lever.position.y = [2,-2][int(action)]
	lever.offset.y = [0,-2][int(action)]
	rl_pos = [-70,70][int(action)]


func do_reload() -> void:
	if ammo < ammo_cap:
		machine.send_event("reload")

func _on_idle_state_entered() -> void:
	play("idle")


func _on_animation_finished() -> void:
	machine.send_event("ani_done")


func _on_fire_state_entered() -> void:
	play("fire")


func _on_reload_state_entered() -> void:
	var lod = get_tree().create_tween()
	lod.tween_property(lever,"rotation_degrees",rl_pos,reload_speed/2)
	lod.tween_property(lever,"rotation_degrees",0,reload_speed/2)
	await lod.finished
	machine.send_event("reloaded")
