class_name Bullet
extends RigidBody2D

var speed : int = 2500
var rng : int = 800
var distance : float = 0
var dmg : int = 1

func _ready() -> void:
	max_contacts_reported = dmg

func _physics_process(delta: float) -> void:
	distance += speed*delta
	if distance > rng:
		queue_free()
	global_position += Vector2(speed*delta,0).rotated(global_rotation)




func _on_dmg_body_entered(body: Node) -> void:
	if body is Cat:
		dmg = body.take_dmg(dmg)
		if dmg <= 0:
			queue_free()
	
