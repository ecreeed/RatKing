class_name Bullet
extends RigidBody2D

var speed : int = 2500
var rng : int = 800
var distance : float = 0
var dmg : int = 1

func _physics_process(delta: float) -> void:
	distance += speed*delta
	if distance > rng:
		queue_free()
	global_position += Vector2(speed*delta,0).rotated(global_rotation)




func _on_body_entered(body: Node) -> void:
	if body is Cat:
		body.take_dmg(dmg)
	
