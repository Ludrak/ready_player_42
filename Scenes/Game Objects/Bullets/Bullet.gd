extends Area2D

var		IMPACT_FORCE = 5

var		START_SPEED = 45

var		velocity

var		enabled = true

var		bullet_force = 30
var		bullet_lifetime = 150

export (PackedScene) var	bullet_explosion = preload("res://Scenes/Game Objects/Bullets/BulletsExplosions/BulletExplosion.tscn")

func	_ready():
	#init_velocity(Vector2(1, 1
	gravity = 0
	$GunFlash.emitting = true
	pass
	
func	_process(delta):
	print (bullet_lifetime);
	self.bullet_lifetime -= 100 * delta
	if (self.bullet_lifetime * 100 <= 0):
		self.destroy()
	
	
func	_physics_process(delta):
	velocity.y += gravity
	#var collision = move_and_collide(velocity * START_SPEED * delta, true, true, false);
	#self.linear_velocity =
	self.position += velocity * START_SPEED * delta

	#add_force(self.velocity, Vector2(START_SPEED * delta, START_SPEED * delta))
	
func	init_velocity(vel, shooter_vel):
	self.velocity = vel * START_SPEED;
	self.velocity += shooter_vel / 100
	
func	destroy():
	var	explosion_instance = bullet_explosion.instance()
	explosion_instance.global_position = self.global_position
	if (get_parent()) :
		get_parent().add_child(explosion_instance)
	explosion_instance.get_node("CPUParticles2D").emitting = true
	
	if (get_parent() != null):
		get_parent().remove_child(self)
		queue_free()
	pass

var	bounces = 0
var	max_bounces = 3
func _on_Bullet_body_entered(body):
	bounces += 1
	if (bounces > max_bounces):
		self.destroy()
	else:
		if (body.has_method("damage")):
			body.damage(self, bullet_force)
		if (body.has_method("get_normal")):
			self.velocity *= body.get_normal()
		else:
			self.destroy()
