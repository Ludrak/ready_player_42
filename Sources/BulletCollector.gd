extends Node2D

func _ready():
	pass # Replace with function body.
	
func	on_fire_bullet(bullet : Node2D, direction : Vector2):
	bullet.init_velocity(direction)
	add_child(bullet)
