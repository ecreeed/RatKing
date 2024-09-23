class_name Cat
extends  CharacterBody2D

@export var target : Player
var battle : Main
var dead = false

@onready var head : Node2D = $Head
@onready var anim : AnimatedSprite2D = $Animation

var speed : int
var HP : int
var dmg : int

func _ready() -> void:
	anim.play("run")
	get_tree().create_tween().tween_property(self,"modulate",Color(1,1,1,1),0.5)

func _physics_process(delta: float) -> void:
	do_head()
	chase(delta)
	

func init(diff: int) -> void:
	HP = diff
	speed = 8000 + 3000 * diff
	dmg = diff
	modulate = Color(0,0,0,0)

func do_head() -> void:
	if target:
		head.look_at(target.global_position)
		head.rotation_degrees -= 90
		anim.flip_h = head.global_rotation_degrees > 0
		head.rotation_degrees += 90


func chase(delta: float) -> void:
	velocity = Vector2(speed*delta,0).rotated(head.global_rotation)
	move_and_slide()


func _on_attack_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_dmg(1)
		die()


func _on_animation_animation_finished() -> void:
	queue_free()

func die() -> void:
	$hitbox.scale *= 0
	$Attack.scale *= 0
	speed = 0
	anim.play("explosion")

func take_dmg(lcl_dmg: int) -> int:
	if dead:
		return lcl_dmg
	var flash = get_tree().create_tween()
	flash.tween_property(anim,"modulate",Color.RED,0.2)
	flash.tween_property(anim,"modulate",Color.WHITE,0.2)
	var output = lcl_dmg - HP
	HP -= lcl_dmg
	if HP <= 0:
		dead = true
		battle.spawn_cheese(global_position,dmg)
		die()
	return output
