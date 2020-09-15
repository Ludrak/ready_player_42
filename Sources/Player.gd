extends KinematicBody2D

export (int) var jump_speed = -400
export (int) var gravity = 1200

var velocity = Vector2()
var jumping = false

func get_input():
	velocity.x = 0
	
	# Key States
	var jump = Input.is_action_just_pressed('ui_select')
#	var right = Input.is_action_pressed('ui_right')
#	var left = Input.is_action_pressed('ui_left')
	
	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get input
	get_input()
	# Apply gravity
	velocity.y += gravity * delta
	# Check jump state
	if jumping and is_on_floor():
		jumping = false
	# Move
	velocity = move_and_slide(velocity, Vector2(0, -1))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
