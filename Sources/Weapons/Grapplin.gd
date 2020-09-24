extends "res://Sources/Weapons/Weapon.gd"
		
func	_on_shoot(target, shooter):
	$Hook.add_force(get_global_mouse_position() - self.global_position, Vector2(100, 100))
	pass


func _ready():
	pass # Replace with function body.
