class_name Pop
extends Node2D

var rodent : String

const info : Dictionary = {
	"rat": "+ DMG",
	"capybara" : "+ HP",
	"porcupine" : "+ Bullet",
	"chipmunk" : "+ Cheese",
	"beaver" : "+ Reload",
	"mouse" : "+ Rate",
	"chinchilla" : "+ Speed",
	"squirrel" : "+ Regen",
	"ferret" : "+ Capacity"
}


func _ready() -> void:
	$Rat.play(rodent)
	$Name.text = rodent
	$Info.text = info[rodent]
	scale *= 0
	var ani = get_tree().create_tween()
	ani.tween_property(self,"scale",Vector2(0.8,0.8),1)
	ani.tween_interval(2)
	ani.tween_property(self,"scale",Vector2(0,0),2.5)
	ani.parallel()
	ani.tween_property(self,"position",Vector2(0,0),2.5)
	await ani.finished
	queue_free()
