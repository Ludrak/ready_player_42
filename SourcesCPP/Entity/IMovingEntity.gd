##	RADROIDS v0.0
##
## == IMovingEntity ==
##
##
##
##
##
##

extends IEntity#"res://SourcesCPP/Entity/IEntity.gd"

class_name IMovingEntity

export (int) var	SPEED = 100
export (int) var	GRAVITY = 98
export (bool) var	HAS_GRAVITY = true setget set_gravity

export (float) var	MAX_SLOPE_ANGLE = 0.80
export (bool) var	INFINITE_INERTIA = false
export (bool) var	STICK_ON_SLOPE = false

export (float) var	FLOOR_FRICTION = 0
export (float) var	AIR_FRICTION = 0

var					velocity = Vector2.ZERO setget set_velocity
var					direction = Vector2.ZERO setget set_direction


##	SET_DIRECTION
##	- Sets the direction of the entity (WARNING: changing this will also affect velocity)
func	set_direction(new_dir: Vector2):
	direction = new_dir.normalized()
	velocity = direction * velocity.length()

##	SET_GRAVITY
##	- Use this to disable/enable gravity on current entity
func	set_gravity(new_gravity: bool):
	HAS_GRAVITY = new_gravity
	if (!HAS_GRAVITY):
		GRAVITY = 0

##	SET_VELOCITY
##	- Sets the velocity of the current entity (WARNING: changing this will also affect direction)
func	set_velocity(new_velocity: Vector2):
	velocity = new_velocity
	direction = velocity.normalized()

##	FLIP_V
##	- Flips the current entity on veritcal axis
func	flip_v():
	scale.x = -scale.x


func	_physics_process(delta):
	if (HAS_GRAVITY && !is_on_floor()):
		velocity.y += GRAVITY
	if (direction.x < 0 && scale.x > 0):
		flip_v()
	elif (direction.x > 0 && scale.x < 0):
		flip_v()
	velocity = move_and_slide(velocity, Vector2(0, -1), STICK_ON_SLOPE, 4, MAX_SLOPE_ANGLE, INFINITE_INERTIA)
	if (is_on_floor() or !is_on_wall()):
		velocity.x /= 1 + FLOOR_FRICTION
	elif(!is_on_wall()):
		velocity.x /= 1 + AIR_FRICTION
		velocity.y /= 1 + AIR_FRICTION
