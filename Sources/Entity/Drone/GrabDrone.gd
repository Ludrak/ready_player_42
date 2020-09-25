extends KinematicBody2D

export (int) var DRONE_SPEED = 400
export (float) var AIR_FRICTION = 0.5

var	velocity = Vector2.ZERO

var	body_target = null

var	body_has_grabbed = false

var	max_health = 80
var	health = max_health

var player_offset = 120


func _ready():
	pass # Replace with function body.

var	x_sin = 0

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
		velocity /= 1 + AIR_FRICTION
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (body_has_grabbed):
		move_self()
	else:
		velocity.y = sin(x_sin) * 25
	move_and_slide(velocity)
	x_sin += delta * 3
	pass
	
func _process(delta):
	$Smoke.amount = health / max_health * 50
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
	get_parent().remove_child(self)
	queue_free()
	pass
