extends IWeapon#"res://Sources/Weapons/Weapon.gd"

signal	fire_bullet


export (bool) var follow_mouse = false setget set_follow_mouse

const			LERP_RECOIL = 0.2
var				max_recoil = 150;
var				recoil_anim_amount = 0;
var				has_current_recoil = false;

func	_ready():
	bullet = load("res://Scenes/Game Objects/Bullets/Bullet.tscn")
	pass

func	_on_enabled(new_enabled):
	follow_mouse = new_enabled
	$Bullet.enabled = new_enabled

func 	set_follow_mouse(new_follow_mouse):
	follow_mouse = new_follow_mouse

func	_on_shoot(target):
	print ("Shooting")
	var rel_target = target - global_position#$Bullet.global_position
	#var distance = rel_target.length()
	#var	rotation = clamp(-rel_target.normalized().angle(), -deg2rad(30), deg2rad(80))
	var direction;
	if (!shooter.is_on_floor()) :
		direction = rel_target.normalized()
	else:
		direction = Vector2(cos(global_rotation), sin(global_rotation))
	var	projectile = bullet.instance()
	
	recoil_anim_amount = max_recoil
	has_current_recoil = true
	
	projectile.global_position = global_position
	emit_signal("fire_bullet", projectile, direction, shooter)
	print (str("Instantiating bullet at :", projectile.position))
	
func	_physics_process(_delta):
	if (has_current_recoil):
		recoil_anim_amount = lerp(recoil_anim_amount, max_recoil, LERP_RECOIL)
		if (recoil_anim_amount >= max_recoil):
			has_current_recoil = false
	else:
		recoil_anim_amount = lerp(recoil_anim_amount, 0, LERP_RECOIL)

func	_process(_delta):
	position.x = -cos(rotation) * recoil_anim_amount
	position.y = -sin(rotation) * recoil_anim_amount;
	
	if follow_mouse:
		var mouse_pos = get_global_mouse_position()
		look_at(mouse_pos)
		if (shooter.is_on_floor() || (!shooter.is_jumping)): 
			rotation = clamp(rotation, -deg2rad(70), deg2rad(30))
		#$Sprite.flip_h = mouse_pos.x < global_position.x
