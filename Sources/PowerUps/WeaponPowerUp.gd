extends Node2D

export (PackedScene) var weapon = preload("res://Scenes/Game Objects/Weapons/Weapon.tscn")

var weapon_instance = weapon.instance()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(weapon_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_body_entered(body):
	remove_child(weapon_instance)
	queue_free()
	body.weapon = weapon_instance
