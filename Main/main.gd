class_name Main
extends Node2D

const cam_speed = 5
var interval = 5

var sys : System

@onready var camera : Camera2D = $Camera
@onready var player : Player = $Player
@onready var HP_cnt : Label = $Canvas/Health
@onready var time_cnt : Label = $Canvas/Time
@onready var ammo_bar : ProgressBar = $Canvas/Mag/Ammo
@onready var load_bar : ProgressBar = $Canvas/Mag/Reload
@onready var timer : Timer = $Timer
@onready var cheese_bar : ProgressBar = $Canvas/Cheese/Amount
@onready var cheese_lvl : Label = $Canvas/Cheese/Level
@onready var pause_menu : PauseMenu = $Pause


func _ready() -> void:
	player.battle = self
	set_HP(player.HP)
	ammo_bar.max_value = player.gun.ammo_cap
	ammo_bar.value = player.gun.ammo
	load_bar.value = 0
	cheese_bar.value = 0
	cheese_bar.max_value = 5
	cheese_lvl.text = "1"
	pause_menu.battle = self
	$Death.visible = false

func _physics_process(delta: float) -> void:
	set_camera(delta)
	if Input.is_action_just_pressed("pause"):
		pause(true)


func set_camera(delta: float) -> void:
	camera.global_position = camera.global_position.lerp(player.global_position, cam_speed*delta)


func set_ammo(new_val: int) -> void:
	get_tree().create_tween().tween_property(ammo_bar,"value",new_val,0.1)


func reload_ammo(new_val: int, reload_speed: float) -> void:
	var load_tw = get_tree().create_tween()
	load_tw.tween_property(load_bar,"value",100,reload_speed)
	load_tw.tween_property(load_bar,"value",0,0)
	load_tw.tween_property(ammo_bar,"value",new_val,0.1)


func set_HP(new_val: int) -> void:
	HP_cnt.text = "♥ " + str(new_val)
	var flash = get_tree().create_tween()
	flash.tween_property(HP_cnt,"scale",Vector2(1.2,1.2),0.2)
	flash.tween_property(HP_cnt,"scale",Vector2(1,1),0.2)


func _on_timer_timeout() -> void:
	time_cnt.text = str(int(time_cnt.text) + 1)
	if int(time_cnt.text) % interval == 0:
		spawn_enemy(int(time_cnt.text)/30 + 1,int(time_cnt.text)/200 + 1)
	elif int(time_cnt.text) % 2 == 0:
		spawn_cheese(player.global_position + Vector2(1000,0).rotated(randi_range(0,360)))


func spawn_enemy(count: int, diff: int) -> void:
	for i in range(count):
		var new_cat = preload("res://Cat/cat.tscn").instantiate()
		new_cat.target = player
		new_cat.init(diff)
		new_cat.battle = self
		new_cat.global_position = player.global_position + Vector2(1000,0).rotated(randi_range(0,360))
		add_child(new_cat)


func spawn_cheese(pos: Vector2, level: int=1) -> void:
	var new_cheese : Cheese = preload("res://Cheese/cheese.tscn").instantiate()
	new_cheese.global_position = pos
	new_cheese.level = level
	call_deferred("add_child",new_cheese)

func pause(on: bool) -> void:
	pause_menu.visible = on
	get_tree().paused = on


func death() -> void:
	get_tree().paused = true
	$Death.visible = true
	$Death/Score.text = str(int(time_cnt.text) * player.rats)
	


func _on_menu_pressed() -> void:
	sys.change_scene("res://Menus/home.tscn")
