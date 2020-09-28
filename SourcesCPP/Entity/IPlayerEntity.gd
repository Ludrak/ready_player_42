## RADROIDS v0.0
##
## == IPlayerEntity ==
##
extends IMovingEntity#"res://SourcesCPP/Entity/IMovingEntity.gd"

class_name IPlayerEntity

var					weapon = null setget set_weapon
onready var			attributes = $Attributes
onready var			animator = $AnimationTree

export (int) var	MAX_JUMP_TIME = 5
export (int) var	JUMP_FORCE = 1200
var					current_jump_time = 0

var					is_jumping = false
var					is_falling = false

var					coins = 0

#                   Networking
var					UUID = 0 # TODO

#					Animation
export (float) var	LERP_TO_RUN_ANIM = 0.3
export (float) var	LERP_TO_FALL_ANIM = 0.2
export (float) var	LERP_TO_JUMP_ANIM = 0.1


##	Setting basic class info
func	_ready():
	FLOOR_FRICTION = 0.2
	AIR_FRICTION = 0.01
	SPEED = 750



##	ANIMATE		<ABSTRACT METHOD>
##	- Override this with your animation sequencer
##	ANIMATE <OVERRIDE>
##	- Overriden from IPlayerEntity
func animate():
	if (!is_jumping && !is_falling):
		#not jumping and fall
		animator.set("parameters/Is_Jumping/add_amount", 0)
		animator.set("parameters/Is_Falling/add_amount", 0)
		##	HAS WEAPON
		##
		if (weapon):
			animator.set("parameters/Has_Weapon_Run/add_amount", 1)
			animator.set("parameters/Has_Weapon_Idle/add_amount", 1)
		else :
			animator.set("parameters/Has_Weapon_Run/add_amount", 0)
			animator.set("parameters/Has_Weapon_Idle/add_amount", 0)
			
		##	IS RUNNING
		##
		if (velocity.length() > 0.1) :
			var	lerp_to = lerp (animator.get("parameters/Idle_Run_Blend/blend_amount"), 0, LERP_TO_RUN_ANIM)
			animator.set("parameters/Idle_Run_Blend/blend_amount", lerp_to)
		else :
			var	lerp_to = lerp (animator.get("parameters/Idle_Run_Blend/blend_amount"), 1, LERP_TO_RUN_ANIM)
			animator.set("parameters/Idle_Run_Blend/blend_amount", lerp_to)
	elif is_falling:
		var	lerp_to = lerp (animator.get("parameters/Is_Falling/add_amount"), 1, LERP_TO_FALL_ANIM)
		animator.set("parameters/Is_Falling/add_amount", lerp_to)
		pass
	else :
		#not falling
		$AnimationTree.set("parameters/Is_Falling/add_amount", 0)
		#jumping
		var	lerp_to = lerp ($AnimationTree.get("parameters/Is_Jumping/add_amount"), 1, LERP_TO_JUMP_ANIM)
		$AnimationTree.set("parameters/Is_Jumping/add_amount", lerp_to)



##	GET_INPUT	<ABSTRACT METHOD>
##	- Override this to implement movement to entity
func	get_input():
	pass



##	SET_WEAPON
##	- Sets the current weapon of the entity
func	set_weapon(new_weapon: IWeapon):
	## TODO weapon script
	pass



##	CAN_JUMP
##	- Determines if the entity is able to jump
func	can_jump():
	if (is_on_floor() or is_jumping):
		return (true)
	return (false)



##	JUMP
##	- Use this to make the entity jump based on amount
func	jump():
	if (can_jump()):
		is_jumping = true
	pass



func	_process(delta):
	animate()



func	_physics_process(delta):
	if (!is_on_wall() or is_on_floor()):
		get_input()
	if (!is_on_floor() && velocity.y > 0):
		is_falling = true
		is_jumping = false
	else:
		is_falling = false
	if (is_jumping):
		if (current_jump_time > MAX_JUMP_TIME or is_on_ceiling() or !is_jumping):
			current_jump_time = 0
			is_jumping = false
		velocity.y = -JUMP_FORCE
		current_jump_time += 10 * delta
	pass
