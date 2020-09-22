extends Area2D

var		IMPACT_FORCE = 5

var		START_SPEED = 45

var		velocity

var		enabled = true

var		bullet_force = 30
var		bullet_lifetime = 150

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
	
func	init_velocity(dir):
	self.velocity = dir * START_SPEED
	
func	destroy():
	if (get_parent() != null):
		get_parent().remove_child(self)
		queue_free()
	pass


func _on_Bullet_body_entered(body):

	if (body.has_method("damage")):
		body.damage(self, bullet_force)
		self.destroy()
		return
	#yield(get_tree().create_timer(0.5),"timeout")
	self.destroy()
