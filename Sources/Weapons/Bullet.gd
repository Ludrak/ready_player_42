extends Line2D

export (bool) var enabled = false setget set_enabled
export (int) var fade_speed = 10

func set_enabled(new_enabled):
	enabled = new_enabled
	$RayCast2D.enabled = enabled

func fire(target):
	points[0] = Vector2.ZERO
	points[1] = target
	$RayCast2D.cast_to = target
	$RayCast2D.force_raycast_update()
	var enemy = $RayCast2D.get_collider()
	if enemy != null and enemy.has_method("kill"):
		default_color =  Color(1, 0.5, 0.4, 1)
		print("Shot '", enemy.name, "' with '", name, "'!")
		enemy.kill(self)
	else:
		default_color =  Color(0.4, 0.5, 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if default_color.a > 0:
		default_color.a -= delta * fade_speed
