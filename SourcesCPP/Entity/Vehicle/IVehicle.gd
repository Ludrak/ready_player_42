#  RADROIDS v0.0
#
#  == IVehicle ==
#
#
extends IMovingEntity

class_name IVehicle

var						body_target = null
var						body_has_grabbed = false setget set_grabbed

export (Vector2) var	slot = Vector2.ZERO

#						Animation
onready var				x_rand = rand_range(0, 1000)
onready var				x_sin = x_rand

func	animate_body():
	if (body_target && body_target.animator != null):
		_on_animate_body()
	pass



##	_ON_ANIMATE_BODY	<ABSTRCT METHOD>
##
func	_on_animate_body():
	pass



##	MOVE_SELF	<ABSTRACT METHOD>
##
func	get_input():
	pass


func	_physics_process(delta):
	if (body_has_grabbed && body_target):
		get_input()
		body_target.global_position = global_position + slot


func	set_grabbed(new_grabbed):
	body_has_grabbed = new_grabbed
	if (body_has_grabbed):
		body_target.set_grab_vehicle(self)
	else :
		body_target.set_grab_vehicle(null)


func	_process(delta):
	animate_body()
	x_sin	+= delta
	var	action = Input.is_action_just_pressed("ui_select")
	if (body_target && !body_has_grabbed && action):
		body_has_grabbed = true
	elif (body_has_grabbed && action):
		body_has_grabbed = false

