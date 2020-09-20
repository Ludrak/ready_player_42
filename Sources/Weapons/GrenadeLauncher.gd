extends "res://Sources/Weapons/Weapon.gd"

export (PackedScene) var grenade = preload("res://Scenes/Game Objects/Weapons/Grenade.tscn")
export (Vector2) var launch_force = Vector2(0, -200)

func _on_shoot(target):
	var grenade_instance = grenade.instance()
	grenade_instance.target = target
	grenade_instance.force = launch_force
	add_child(grenade_instance)
