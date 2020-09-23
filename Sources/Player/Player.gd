
extends KinematicBody2D

export (NodePath) var		bullet_collector = "../BulletCollector"

export (float) var	LERP_TO_SPEED_ANIM = 0.3
export (float) var	LERP_TO_JUMP_ANIM = 0.1
export (float) var	LERP_TO_FALL_ANIM = 0.05

export (int) var	LERP_TO_FULLSPEED = 0.5
export (int) var	FRICTION_LEVEL = 0.9999
export (int) var	SPEED =  700 # 23000

export (int) var	jump_speed = 1200
export (int) var	gravity = 98

onready var attributes = $Attributes

onready var		health = attributes.max_health.amount

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

onready var	hand = $PlayerBody/Skeleton/Hip/Chest/ArmR_top/ArmR_bottom/HandR

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
		
	weapon.position = hand.get_node("HandAttachement").position
	weapon.rotation = hand.get_node("HandAttachement").rotation
	weapon.scale = Vector2(2, 2)#hand.get_node("HandAttachement").scale
	weapon.z_index = 1;
	hand.add_child(weapon)
	weapon.connect("fire_bullet", get_node(bullet_collector), "on_fire_bullet")

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
		
	#if (shoot && get_viewport().get_mouse_position().x > get_viewport().size.x / 2) && !right && !left:
#	set_facing(1)
	#else:
	#	set_facing(-1)


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
func _physics_process(_delta):
	# Get input
	if !is_on_wall() or is_on_floor():
		get_input()
	# Apply gravity
	if !is_on_floor() || is_on_wall():
		velocity.y += gravity
	velocity.linear_interpolate(Vector2(0, velocity.y), FRICTION_LEVEL)
	velocity = move_and_slide(velocity, Vector2(0, -1), false, 4, 0.80, false)

	if (velocity.y > 0 && !is_on_floor() && jumps > 0 && !jumping):
		falling = true
	else :
		falling = false
	# Update jump state
	if jumps > 0 and is_on_floor():
		jumps = 0

	if (!jumping && jumps == 0 && !falling):
		#not jumping and fall
		$AnimationTree.set("parameters/Is_Jumping/add_amount", 0)
		$AnimationPlayer.set("parameters/Is_Falling/add_amount", 0)
		##	HAS WEAPON
		##
		if (self.weapon):
			$AnimationTree.set("parameters/Has_Weapon_Run/add_amount", 1)
			$AnimationTree.set("parameters/Has_Weapon_Idle/add_amount", 1)
		else :
			$AnimationTree.set("parameters/Has_Weapon_Run/add_amount", 0)
			$AnimationTree.set("parameters/Has_Weapon_Idle/add_amount", 0)
			
		##	IS RUNNING
		##
		if (self.velocity.length() > 0.1) :
			var	lerp_to = lerp ($AnimationTree.get("parameters/Idle_Run_Blend/blend_amount"), 0, LERP_TO_SPEED_ANIM)
			print(str("blend :", lerp_to))
			$AnimationTree.set("parameters/Idle_Run_Blend/blend_amount", lerp_to)
		else :
			var	lerp_to = lerp ($AnimationTree.get("parameters/Idle_Run_Blend/blend_amount"), 1, LERP_TO_SPEED_ANIM)
			$AnimationTree.set("parameters/Idle_Run_Blend/blend_amount", lerp_to)
	elif falling:
		var	lerp_to = lerp ($AnimationTree.get("parameters/Is_Falling/add_amount"), 1, LERP_TO_FALL_ANIM)
		$AnimationTree.set("parameters/Is_Falling/add_amount", lerp_to)
		pass
	else :
		#not falling
		$AnimationPlayer.set("parameters/Is_Falling/add_amount", 0)
		#jumping
		var	lerp_to = lerp ($AnimationTree.get("parameters/Is_Jumping/add_amount"), 1, LERP_TO_JUMP_ANIM)
		$AnimationTree.set("parameters/Is_Jumping/add_amount", lerp_to)




# Called when the node enters the scene tree for the first time.
func _ready():
	print("'", name, "' entered the scene!")

func	damage(damager: Node, amount: int):
	self.health -= amount;
	if (self.health >= 0):
		self.health = 0
		self.kill(damager)
	
func	kill(killer: Node):
	print("Killed by '", killer.name, "'!")
	self.position = self.spawn_pos
	#queue_free()
