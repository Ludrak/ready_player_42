tool

extends Node2D

export (PackedScene) var weapon = preload("res://Scenes/Game Objects/Weapons/FireArm.tscn")

onready var weapon_instance = weapon.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("'", name, "' entered the scene!")
	add_child(weapon_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_body_entered(body):
	remove_child(weapon_instance)
	queue_free()
	weapon_instance.set_shooter(body)
	body.weapon = weapon_instance
