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
	var shoot = Input.is_action_pressed("ui_use_weapon")
	
	if (right && left):
		pass
	elif (right):
		set_facing(1)
		set_velocity(Vector2(SPEED, velocity.y))
	elif (left):
		set_facing(-1)
		set_velocity(Vector2(-SPEED, velocity.y))
	
	if (jump):
		jump()
	else:
		is_jumping = false
		
	if (shoot && weapon && weapon.has_method("shoot")):
		if (get_viewport().get_mouse_position().x > OS.get_window_size().x / 2 && facing < 0 && !left):
			set_facing(-facing)
		elif (get_viewport().get_mouse_position().x < OS.get_window_size().x / 2 && facing > 0 && !right):
			set_facing(-facing)
		weapon.shoot(get_global_mouse_position())



func	kill(_killer: Node2D):
	position = spawn_point
