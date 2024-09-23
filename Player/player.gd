class_name Player
extends CharacterBody2D

const rodents = ["rat","capybara","porcupine","chipmunk","beaver","mouse","chinchilla","squirrel","ferret"]

var speed = 1000
var cheese = 0
var rats = 1
var gain_mod = 1
var Max_HP = 10
var HP = 10
var regen = 0

var held_item : String = ""
var item_active : bool = false

@onready var art = $Art
@onready var aim = $Aim
@onready var gun : Gun = $Aim/Gun
@onready var timer: Timer = $ItmTimer

@onready var battle : Main


func _ready() -> void:
	add_rat()

func _physics_process(delta: float) -> void:
	aim_gun()
	movement(delta)
	spin()
	if Input.is_action_pressed("left_click"):
		gun.shoot()
	if Input.is_action_pressed("reload"):
		gun.do_reload()
	if Input.is_action_just_pressed("item"):
		activate_item()
	if Input.is_action_just_pressed("discard") and !item_active:
		held_item = ""
		battle.display_item()

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

func add_rat(rodent:String="rat") -> void:
	var new_rat = preload("res://Player/rat.tscn").instantiate()
	var shade = randf_range(1,0.5)
	new_rat.modulate = Color(shade,shade,shade)
	new_rat.modulate.a = 0
	new_rat.play(rodent)
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

func take_dmg(dmg: int) -> void:
	if held_item == "mushroom" and item_active:
		return
	HP -= dmg
	$Hurt.play()
	battle.set_HP(HP)
	var flash = get_tree().create_tween()
	flash.tween_property(art,"modulate",Color.RED,0.2)
	flash.tween_property(art,"modulate",Color.WHITE,0.2)
	if HP <= 0:
		battle.death()

func add_cheese(cheese_lvl: int) -> void:
	if randi_range(0,100) < regen and HP < Max_HP:
		HP += 1
		battle.set_HP(HP)

	cheese += gain_mod*cheese_lvl
	if rats < 50:
		if cheese >= rats*5:
			cheese -= rats*5
			level_up()
		if rats < 50:
			get_tree().create_tween().tween_property(battle.cheese_bar,"value",cheese,0.1)
		else:
			battle.cheese_bar.value = battle.cheese_bar.max_value

func level_up() -> void:
	rats += 1
	$Level.play()
	var upgrade = rodents[randi_range(0,rodents.size()-1)]
	match upgrade:
		"rat":
			gun.dmg += 1
		"capybara":
			HP += 1
			battle.set_HP(HP)
			Max_HP += 2
		"porcupine":
			gun.pjtl_cnt += 1
		"chipmunk":
			$Pickup.scale += Vector2(1.2,1.2)
		"beaver":
			gun.reload_amount += 1
		"mouse":
			gun.fire_speed /= 1.5
		"chinchilla":
			speed += 200
		"squirrel":
			regen += 5
		"ferret":
			gun.ammo_cap += 1
			battle.ammo_bar.max_value = gun.ammo_cap
	
	if HP < Max_HP:
		HP += 1
		battle.set_HP(HP)
	add_rat(upgrade)
	
	var popup = preload("res://UI/popup.tscn").instantiate()
	popup.rodent = upgrade
	popup.position = Vector2(250,0).rotated(randi_range(0,360))
	add_child(popup)
	if rats % 15 == 0 and battle.interval > 1:
		battle.interval -= 1
	
	if rats <= 50:
		battle.cheese_bar.max_value = rats*5
		battle.cheese_lvl.text = str(rats)

func pickup(type) -> void:
	$Grab.play()
	held_item = type
	battle.display_item()

func activate_item() -> void:
	if item_active:
		return

	if held_item != "":
		item_active = true
		battle.itemheld.modulate = Color.DIM_GRAY
		if held_item != "grenade":
			$Eat.play()

	match held_item:
		"cracker":
			gain_mod = 5
			timer.start()
		"ammo":
			gun.endless = true
			timer.start()
		"mushroom":
			timer.start()
		"grenade":
			throw_grenade()

func _on_itm_timer_timeout() -> void:
	$Fart.play()
	match held_item:
		"cracker":
			gain_mod = 1
		"ammo":
			gun.endless = false
	
	battle.itemheld.modulate = Color.WHITE
	held_item = ""
	item_active = false
	battle.display_item()


func throw_grenade() -> void:
	var nade : Grenade = preload("res://Items/grenade.tscn").instantiate()
	nade.global_position = global_position
	nade.rotation_degrees = aim.rotation_degrees
	get_tree().get_root().add_child(nade)
	
	battle.itemheld.modulate = Color.WHITE
	held_item = ""
	item_active = false
	battle.display_item()
