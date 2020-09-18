extends Node2D

const Cooldown = preload("res://Sources/Cooldown.gd")

export (int) var bullet_count = 10
export (int) var bullet_range = 10000
export (bool) var enabled = false setget set_enabled
export (bool) var follow_mouse = false setget set_follow_mouse
export (int) var shoot_cooldown_ms = 500

onready var shoot_cooldown = Cooldown.new(shoot_cooldown_ms / 1000.0)

func set_enabled(new_enabled):
	enabled = new_enabled
	follow_mouse = enabled
	$Bullet.enabled = enabled

func set_follow_mouse(new_follow_mouse):
	follow_mouse = new_follow_mouse

func can_shoot():
	var bullets_left = bullet_count == -1 or bullet_count > 0
	return bullets_left and shoot_cooldown.is_ready()

func shoot(target):
	if can_shoot():
		var rel_target = target - $Bullet.global_position
		var distance = rel_target.length()
		var direction = rel_target / distance

		if (distance < bullet_range):
			$Bullet.fire(rel_target)
		else:
			$Bullet.fire(direction * bullet_range)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if follow_mouse:
		var mouse_pos = get_global_mouse_position()
		$Sprite.look_at(mouse_pos)
		#$Sprite.flip_h = mouse_pos.x < global_position.x
	if enabled:
		shoot_cooldown.tick(delta)
