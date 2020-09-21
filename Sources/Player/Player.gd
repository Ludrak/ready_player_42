extends KinematicBody2D

export (int) var	LERP_TO_FULLSPEED = 0.5
export (int) var	FRICTION_LEVEL = 0.9999
export (int) var	SPEED =  700 # 23000

export (int) var	jump_speed = 1200
export (int) var	gravity = 98

onready var attributes = $Attributes

onready var spawn_pos = self.position

var	direction = "none"

var velocity = Vector2.ZERO
var jumps = 0

onready var	old_facing = self.get_scale().x
onready var	facing = old_facing

var	jumping = false
var	falling = false

export (int) var		MAX_JUMP_DELAY = 20
var					current_jump_delay = 0
var weapon = null setget set_weapon
var coins = 0 setget set_coins

func set_weapon(new_weapon):
	print("Picked up '", new_weapon.name, "'!")
	if weapon != null:
		print("Deleting '", weapon.name, "'!")
		remove_child(weapon)
		weapon.queue_free()
	weapon = new_weapon
	if weapon.get("enabled") != null:
		weapon.enabled = true
	else:
		print("Warning: '", weapon.name, "' has no 'enabled' attribute!")
	add_child(weapon)

func set_coins(new_coins):
	coins = new_coins * attributes.coin_multiplicator.amount
	print("'", name, "' has ", coins, " coins!")

func can_jump():
	return jumps < attributes.max_jumps.amount and (jumping or is_on_floor())

func set_facing( dir ):
	facing = dir
	if old_facing != facing:
		if (old_facing < 0) :
			set_scale(Vector2( -1, -1 ))
		else :
			set_scale(Vector2( -1 , 1 ))
		old_facing = facing

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
	
	## NOT USEFULL
	#if (abs(velocity.x) < 0.001) :
	#	velocity.x = 0

	##	NEED TO LERP
	##	TO SPEED
	if left and right:
		pass
	elif right :
		velocity.x = SPEED#velocity.linear_interpolate(Vector2(SPEED, 0), LERP_TO_FULLSPEED).x #velocity.slerp(Vector2(SPEED, velocity.y), LERP_TO_FULLSPEED * delta)
		set_facing(1)
	elif left :
		velocity.x = -SPEED#velocity.linear_interpolate(Vector2(-SPEED, 0), LERP_TO_FULLSPEED).x #velocity.slerp(Vector2(SPEED, velocity.y), LERP_TO_FULLSPEED * delta)
		set_facing(-1)


	if jump and can_jump():
		velocity.y = -jump_speed
		jumping = true
		current_jump_delay += 1
	
	if shoot and can_shoot():
		if weapon.has_method("shoot"):
			weapon.shoot(get_global_mouse_position())
		else:
			print("Warning: '", weapon.name, "' has no 'shoot' method!")

	if (jumping && !jump) || (current_jump_delay > MAX_JUMP_DELAY) :
		jumps+=1
		current_jump_delay = 0
	#TODO Double jump auto activates due to action_pressed
	if !jump :
		jumping = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get input
	if !is_on_wall() or is_on_floor():
		get_input()
	# Apply gravity
	if !is_on_floor() || is_on_wall():
		velocity.y += gravity
	velocity.linear_interpolate(Vector2(0, velocity.y), FRICTION_LEVEL)
	velocity = move_and_slide(velocity, Vector2(0, -1), false, 4, 0.80, false)

	# Update jump state
	if jumps > 0 and is_on_floor():
		jumps = 0


	if (!jumping && self.velocity.length() > 0.1 && jumps == 0) :
		if (!falling) :
			$AnimationPlayer.play("run", -1, 2, false)
		else :
			$AnimationPlayer.play("jump_end", -1, 2.5, false)
		falling = false
	elif jumping:
		$AnimationPlayer.play("jump_start", -1, 2, false);
		$AnimationPlayer.get_animation("jump_start").loop = false
	elif jumps > 0:
		$AnimationPlayer.play("fall", -1, 2, true);
		falling = true
	else :
		if (!falling) :
			$AnimationPlayer.play("idle", -1, 1, false)
		else :
			$AnimationPlayer.play("jump_end", -1, 2.5, false)
		falling = false
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	print("'", name, "' entered the scene!")

	
func kill(killer: Node):
	print("Killed by '", killer.name, "'!")
	self.position = self.spawn_pos
	#queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
