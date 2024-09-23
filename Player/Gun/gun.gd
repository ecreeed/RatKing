class_name Gun
extends AnimatedSprite2D

@onready var lever : Sprite2D = $Lever
@onready var machine : StateChart = $StateChart

@export var player : Player
var rl_pos = 70
var can_fire = true
var endless = false

var ammo_cap : int = 8
var ammo : int = 8
var reload_amount : int = 1
var reload_speed : float = 0.8
var fire_speed : float = 0.7
var dmg : int = 1
var pjtl_cnt : int = 1
var rng : int = 800


func shoot() -> void:
	if ammo <= 0:
		do_reload()
	elif ammo > 0 and can_fire:
		machine.send_event("shoot")


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


func do_bullet() -> void:
	for i in range(pjtl_cnt):
		var bullet : Bullet = preload("res://Player/Gun/bullet.tscn").instantiate()
		bullet.rotation_degrees = global_rotation_degrees + randf_range(-5,5) * pjtl_cnt
		bullet.rng = rng
		bullet.dmg = dmg
		bullet.global_position = global_position
		get_tree().get_root().add_child(bullet)


func _on_animation_finished() -> void:
	machine.send_event("ani_done")


func _on_fire_state_entered() -> void:
	can_fire = false
	ammo -= (1 - int(endless))
	player.battle.set_ammo(ammo)
	play("fire")
	$Gunshot.play()
	do_bullet()
	await get_tree().create_timer(fire_speed).timeout
	can_fire = true


func _on_reload_state_entered() -> void:
	ammo += reload_amount
	if ammo > ammo_cap:
		ammo = ammo_cap
	$Reload.play()
	player.battle.reload_ammo(ammo,reload_speed)
	var lod = get_tree().create_tween()
	lod.tween_property(lever,"rotation_degrees",rl_pos,reload_speed/2)
	lod.tween_property(lever,"rotation_degrees",0,reload_speed/2)
	await lod.finished
	machine.send_event("reloaded")
