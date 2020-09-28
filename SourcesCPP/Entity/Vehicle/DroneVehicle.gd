extends IVehicle


const	LERP_TO_ANGLE = 0.1
var		sprite_flow_angle = deg2rad(10)

func _on_animate_body():
	body_target.animator.set("parameters/Is_Grabbing_Drone/add_amount", 1)

func _ready():
	SPEED = 400
	set_gravity(false)


func get_input():
	var up = Input.is_action_pressed('ui_up')
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var down = Input.is_action_pressed("ui_down")
	
	if (up):
		velocity.y = -SPEED
	elif (left): 
		velocity.x = -SPEED
	elif (right):
		velocity.x = SPEED
	elif (down):
		velocity.y = SPEED
	else:
		velocity.x /= 1 + AIR_FRICTION
		velocity.y = sin(x_sin + x_rand) * 25
		
	
	if (right):
		$drone.rotation = (lerp($drone.rotation, sprite_flow_angle, LERP_TO_ANGLE))
	elif (left):
		$drone.rotation = (lerp($drone.rotation, -sprite_flow_angle, LERP_TO_ANGLE))
	else:
		$drone.rotation = (lerp($drone.rotation, 0, LERP_TO_ANGLE))


func _on_GrabArea_body_entered(body):
	if body.get_name() == "Player" :
		body_target = body
	pass


func _on_GrabArea_body_exited(body):
	if (body == body_target):
		body_target = null
	pass
	
