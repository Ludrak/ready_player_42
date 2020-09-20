extends "res://Sources/Weapons/Weapon.gd"

export (bool) var follow_mouse = false setget set_follow_mouse

func _on_enabled(new_enabled):
	follow_mouse = new_enabled
	$Bullet.enabled = new_enabled

func set_follow_mouse(new_follow_mouse):
	follow_mouse = new_follow_mouse

func _on_shoot(target):
	var rel_target = target - $Bullet.global_position
	var distance = rel_target.length()
	var direction = rel_target / distance

	if (distance < bullet_range):
		$Bullet.fire(rel_target)
	else:
		$Bullet.fire(direction * bullet_range)

func _process(delta):
	if follow_mouse:
		var mouse_pos = get_global_mouse_position()
		$Sprite.look_at(mouse_pos)
		#$Sprite.flip_h = mouse_pos.x < global_position.x
