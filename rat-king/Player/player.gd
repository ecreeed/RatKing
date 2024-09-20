class_name Player
extends CharacterBody2D

const speed = 1000
var cheese = 0

@onready var art = $Art
@onready var aim = $Aim
@onready var gun : Gun = $Aim/Gun


func _ready() -> void:
	add_rat()

func _physics_process(delta: float) -> void:
	aim_gun()
	movement(delta)
	spin()
	if Input.is_action_just_pressed("left_click"):
		gun.shoot()
	if Input.is_action_just_pressed("reload"):
		gun.do_reload()

func movement(delta: float) -> void:
	var acc = Vector2(0,0)
	
	if Input.is_action_pressed("up"):
		acc.y = -speed * delta
	if Input.is_action_pressed("down"):
		acc.y = speed * delta
	if Input.is_action_pressed("left"):
		acc.x = -speed * delta
	if Input.is_action_pressed("right"):
		acc.x = speed * delta
	
	velocity += acc
	move_and_slide()
	
	velocity *= 0.95
	if velocity.length() < 10:
		velocity *= 0

func spin() -> void:
	var spin_rate : float
	if abs(velocity.x) > 50:
		spin_rate = velocity.x/2000
	else:
		spin_rate = velocity.y/4000
	
	art.rotate(spin_rate)

func add_rat() -> void:
	var new_rat = preload("res://Player/rat.tscn").instantiate()
	new_rat.modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
	new_rat.modulate.a = 0
	new_rat.rotate(randi_range(0,360))
	art.add_child(new_rat)
	get_tree().create_tween().tween_property(new_rat,"modulate:a",1,0.5)

func aim_gun() -> void:
	aim.look_at(get_global_mouse_position())
	aim.rotation_degrees -= 90
	if aim.global_rotation_degrees > 0:
		gun.flip(true)
	else:
		gun.flip(false)
	aim.rotation_degrees += 90
