extends KinematicBody2D

export (int) var	FRICTION_LEVEL = 0.94
export (int) var	SPEED = 400

export (int) var	jump_speed = 500
export (int) var	gravity = 100

onready var attributes = $Attributes

var velocity = Vector2.ZERO
var jumps = 0

var jumping = false
export (int) var MAX_JUMP_DELAY = 20
var current_jump_delay = 0

var weapon = null setget set_weapon
var coins = 0 setget set_coins

func set_weapon(new_weapon):
	print("Picked up '", new_weapon.name, "'!")
	if weapon != null:
		print("Deleting '", weapon.name, "'!")
		remove_child(weapon)
		weapon.queue_free()
	weapon = new_weapon
	weapon.enabled = true
	add_child(weapon)

func set_coins(new_coins):
	coins = new_coins * attributes.coin_multiplicator.amount
	print("'", name, "' has ", coins, " coins!")

func can_jump():
	return jumps < attributes.max_jumps.amount

func can_shoot():
	return weapon != null

func get_input():
	velocity.x = 0
	
	# Key States
	var jump = Input.is_action_pressed('ui_select')
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var shoot = Input.is_action_pressed("ui_use_weapon")
	
	velocity.x /= 1 + FRICTION_LEVEL

	if right :
		velocity.x = SPEED
	elif left :
		velocity.x = -SPEED

	if jump and can_jump():
		velocity.y = -jump_speed
		jumping = true
		current_jump_delay += 1
	
	if shoot and can_shoot():
		weapon.shoot(get_global_mouse_position())

	if (jumping && !jump) || (current_jump_delay > MAX_JUMP_DELAY) :
		jumps+=1
		current_jump_delay = 0
	#TODO Double jump auto activates due to action_pressed
	if !jump :
		jumping = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get input
	get_input()
	# Apply gravity
	velocity.y += gravity
	velocity.linear_interpolate(Vector2(0, velocity.y), FRICTION_LEVEL)
	# Move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	# Update jump state
	if jumps > 0 and is_on_floor():
		jumps = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("'", name, "' entered the scene!")

func kill(enemy):
	print("Killed by '", enemy.name, "'!")
	
	#queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
