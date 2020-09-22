extends Area2D

const	AIR_FRICTION = 0.01
var		IMPACT_FORCE = 5

var		START_SPEED = 40

var		velocity

var		enabled = true

func	_ready():
	#init_velocity(Vector2(1, 1
	gravity = 0
	pass
	
	
func	_physics_process(delta):
	velocity.y += gravity
	velocity.y /= 1 + AIR_FRICTION

	#var collision = move_and_collide(velocity * START_SPEED * delta, true, true, false);
	#self.linear_velocity =
	self.position += velocity * START_SPEED * delta

	#add_force(self.velocity, Vector2(START_SPEED * delta, START_SPEED * delta))
	
func	init_velocity(dir):
	self.velocity = dir * START_SPEED
	
func	destroy():
	get_parent().remove_child(self)
	queue_free()
	pass


func _on_Bullet_body_entered(body):

	if (body.has_method("kill")):
		body.kill(self)
		self.destroy()
		return
	#yield(get_tree().create_timer(0.5),"timeout")
	self.destroy()
