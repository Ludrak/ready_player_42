extends KinematicBody2D

export (int) var DRONE_SPEED = 800
export (float) var AIR_FRICTION = 0.05

var	velocity = Vector2.ZERO

var	body_target = null

var	body_has_grabbed = false

var	max_health = 80
var	health = max_health

var player_offset = 120

const	LERP_TO_ANGLE = 0.1
var		sprite_flow_angle = deg2rad(10)


func _ready():
	pass # Replace with function body.

var	x_sin = 0
var	x_rand = rand_range(0, 1)

func move_self():
	var up = Input.is_action_pressed('ui_up')
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var down = Input.is_action_pressed("ui_down")
	
	if (up):
		velocity.y = -DRONE_SPEED
	elif (left): 
		velocity.x = -DRONE_SPEED
	elif (right):
		velocity.x = DRONE_SPEED
	elif (down):
		velocity.y = DRONE_SPEED
	else:
		velocity.x /= 1 + AIR_FRICTION
		velocity.y = sin(x_sin + x_rand) * 25
		
				
	if (right):
		$drone.rotation = (lerp($drone.rotation, sprite_flow_angle, LERP_TO_ANGLE))
	elif (left):
		$drone.rotation = (lerp($drone.rotation, -sprite_flow_angle, LERP_TO_ANGLE))
	else:
		$drone.rotation = (lerp($drone.rotation, 0, LERP_TO_ANGLE))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (body_has_grabbed):
		move_self()
	else:
		velocity.x /= 1 + AIR_FRICTION
		velocity.y = sin(x_sin) * 25
		
	if (velocity.x > 100):
		$drone.rotation = (lerp($drone.rotation, sprite_flow_angle, LERP_TO_ANGLE))
	elif (velocity.x < -100):
		$drone.rotation = (lerp($drone.rotation, -sprite_flow_angle, LERP_TO_ANGLE))
	else:
		$drone.rotation = (lerp($drone.rotation, 0, LERP_TO_ANGLE))
	move_and_slide(velocity)
	x_sin += delta * 3
	pass
	
func _process(_delta):
	$Smoke.amount = health / max_health * 50
	if ($Smoke.amount == 0):
		$Smoke.emitting = false
	else:
		$Smoke.emitting = true
	if (body_target && body_has_grabbed):
		if (Input.is_action_just_pressed("ui_select")):
			body_target.grab_drone(null)
			body_target = null
			body_has_grabbed = false
		else :
			body_target.global_position = self.position + Vector2(0, player_offset)
			
	if (Input.is_action_just_pressed("ui_select")):
		if body_target && body_target.has_method("grab_drone"):
			body_target.grab_drone(self)
			body_has_grabbed = true
		else:
			body_target = null



func _on_GrabArea_body_entered(body):
	if body.get_name() == "Player" :
		body_target = body
	pass


func _on_GrabArea_body_exited(body):
	if (body == body_target):
		body_target = null
	pass
	
func damage(damager: Node, amount):
	health -= amount
	
	if (health <= 0):
		health = 0
		kill(damager)

func kill(killer: Node):
	print ("killed by :", killer)
	$drone.visible = false
	$Explosion.emitting = true
	$ExplosionSmoke.emitting = true
	yield(get_tree().create_timer(2),"timeout")
	get_parent().remove_child(self)
	queue_free()
	pass


func _on_CollisionShape_body_entered(body):
	if (body != self):
		if (body_has_grabbed):
			body_target.grab_drone(null)
			body_target = null
			body_has_grabbed = false
		self.kill(body)
	pass # Replace with function body.
