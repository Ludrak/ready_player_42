extends IPlayerEntity#"res://SourcesCPP/Entity/IPlayerEntity.gd"

class_name Player

onready var		spawn_point = position

##	GET_INPUT <OVERRIDE>
##	Overridden from IPlayerEntity
func	get_input():
	# Key States
	var jump = Input.is_action_pressed('ui_up')
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	#var shoot = Input.is_action_pressed("ui_use_weapon")
	
	if (right && left):
		pass
	elif (right):
		velocity.x = SPEED
	elif (left):
		velocity.x = -SPEED
	
	if (jump):
		jump()
	else:
		is_jumping = false



func	_on_kill(_killer: Node2D):
	position = spawn_point
