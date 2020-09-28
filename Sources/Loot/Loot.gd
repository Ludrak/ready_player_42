extends RigidBody2D

export (int) var value = 1
export (String) var attribute = "coins"

var magnetic_target = null setget set_magnetic_target

var magnetic_force_self = 2000
var magnetic_force_target = 2000
var magnetic_factor = -300

var magnetic_force = magnetic_factor * magnetic_force_self * magnetic_force_self

func set_magnetic_target(new_magnetic_target):
	print(name, " is attracted to '", magnetic_target.name, "'!")
	magnetic_target = new_magnetic_target

# Called when the node enters the scene tree for the first time.
func _ready():
	print ("'Loot' enteed the scene !")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AttractionArea_body_entered(body):
	if magnetic_target == null:
		magnetic_target = body

func _on_PickUpArea_body_entered(body):
	queue_free()
	visible = false
	var old_value = body.get(attribute)
	if old_value != null:
		body.set(attribute, old_value + value)
	else:
		print("Warning: '", body.name, "' doesn't have the '", attribute, "' attribute!")


func _physics_process(_delta):
	pass

var	x = 0
func _integrate_forces(state):
	var delta = state.step

	var gravity = state.total_gravity
	var magneticity = Vector2.ZERO
	var velocity = state.linear_velocity

	if magnetic_target != null:
		var to_target = magnetic_target.global_position - global_position
		var distance = to_target.length()
		var direction = to_target / distance

		magneticity = direction * (-1 * magnetic_force / (distance * distance))
	state.linear_velocity = (velocity + magneticity - (gravity * ((sin (x)) * 40 * delta - 0.2))) * delta
	x += 5 *  delta
#	print (state.linear_velocity)
