extends KinematicBody2D

export (int) var jump_speed = -400
export (int) var gravity = 1200

onready var attributes = $Attributes

var velocity = Vector2()
var jumps = 0

func can_jump():
	return jumps < attributes.max_jumps.amount

func get_input():
	velocity.x = 0
	
	# Key States
	var jump = Input.is_action_just_pressed('ui_select')
#	var right = Input.is_action_pressed('ui_right')
#	var left = Input.is_action_pressed('ui_left')
	
	if jump and can_jump():
		jumps += 1
		velocity.y = jump_speed
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get input
	get_input()
	# Apply gravity
	velocity.y += gravity * delta
	# Move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	# Update jump state
	if jumps > 0 and is_on_floor():
		jumps = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("'Player' entered the scene!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
