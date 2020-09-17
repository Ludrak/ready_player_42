extends KinematicBody2D

export (int) var	FRICTION_LEVEL = 0.9999
export (int) var	SPEED = 19000

export (int) var	jump_speed = 550
export (int) var	gravity = 1700

onready var attributes = $Attributes

var velocity = Vector2.ZERO
var jumps = 0

var	jumping = false
export (int) var		MAX_JUMP_DELAY = 20
var					current_jump_delay = 0

func can_jump():
	return jumps < attributes.max_jumps.amount

func get_input():
	velocity.x = 0
	
	# Key States
	var jump = Input.is_action_pressed('ui_select')
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	
	velocity.x /= 1 + FRICTION_LEVEL
	
	if (abs(velocity.x) < 0.001) :
		velocity.x = 0

	if right :
		velocity.x = SPEED
	elif left :
		velocity.x = -SPEED

	if jump and can_jump():
		velocity.y = -jump_speed
		jumping = true
		current_jump_delay += 1

	if (jumping && !jump) || (current_jump_delay > MAX_JUMP_DELAY) :
		jumps+=1
		current_jump_delay = 0
	#TODO Double jump auto activates due to action_pressed
	if !jump :
		jumping = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get input
	if !is_on_wall():
		get_input()
	# Apply gravity
	if !is_on_floor():
		velocity.y += gravity * delta
	velocity.x *= delta
	velocity.linear_interpolate(Vector2(0, velocity.y), FRICTION_LEVEL)
	# Move
	#var motionY = Vector2(0, velocity.y) * delta
	var motion = Vector2(velocity.x, velocity.y)# * delta
	#var collision = move_and_collide(motion, true, true, false);
	
	#if (collision && collision.get_normal().angle() < 0.80):
	#	move_and_collide(-motion, true, true, false)
	
	
	velocity = move_and_slide(motion, Vector2(0, -1), false, 4, 0.80, false)
	
	# Update jump state
	if jumps > 0 and is_on_floor():
		jumps = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	print("'", name, "' entered the scene!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
