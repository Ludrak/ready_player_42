## RADROIDS v0.0
##
## == IPlayerEntity ==
##
extends IMovingEntity

class_name IPlayerEntity

var					weapon = null setget set_weapon
onready var			attributes = $Attributes
onready var			animator = $AnimationTree

export (int) var	MAX_JUMP_TIME = 10
export (int) var	JUMP_FORCE = 100
var					current_jump_time = 0

var					is_jumping = false 
var					is_falling = false 



##	ANIMATE		<ABSTRACT METHOD>
##	- Override this with your animation sequencer
func	animate():
	pass



##	GET_INPUT	<ABSTRACT METHOD>
##	- Override this to implement movement to entity
func	get_input(delta):
	pass



##	SET_WEAPON
##	- Sets the current weapon of the entity
func	set_weapon(new_weapon: IWeapon):
	## TODO weapon script
	pass



##	JUMP
##	- Use this to make the entity jump based on amount
func	jump(amount: int):
	is_jumping = true
	pass



func	_process(delta):
	animate()



func	_physics_process(delta):
	if (!is_on_floor() && velocity.y > 0):
		is_falling = true
		is_jumping = false
	else:
		is_falling = false
	if (is_jumping):
		velocity.y = -JUMP_FORCE
		current_jump_time += 10 * delta
		if (current_jump_time > MAX_JUMP_TIME):
			current_jump_time = 0
			is_jumping = false
	get_input(delta)
	._physics_process(delta)
	pass
