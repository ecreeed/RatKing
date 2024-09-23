class_name Grenade
extends RigidBody2D


var speed : int = 900
var rng : int = 700
var distance : float = 0
var dmg : int = 1

func _ready() -> void:
	max_contacts_reported = dmg

func _physics_process(delta: float) -> void:
	distance += speed*delta
	if distance > rng:
		explode()
	global_position += Vector2(speed*delta,0).rotated(global_rotation)

func _on_body_entered(_body: Node) -> void:
	explode()
	
func explode() -> void:
	var expl = preload("res://Items/explosion.tscn").instantiate()
	expl.global_position = global_position
	get_tree().get_root().call_deferred("add_child",expl)
	queue_free()
