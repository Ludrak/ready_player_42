extends Camera2D

const		POSITION_LERP_VALUE = 0.94
const		IDLE_ZOOM_LERP = 0.01
const		ZOOM_LERP = 0.03

const		IDLE_ZOOM = 0.5
const		MOVING_ZOOM = 0.7
const		OUT_OF_BORDER_ZOOM = 1.2

const		PLAYER_TOP_OFFSET = 100

onready var target = get_parent().get_node("Player") setget set_target

func	_ready():
	print("'", name, "' entered the scene!")

func	set_target(new_target):
	target = new_target
	print("'", name, "' target changed to '", target.name, "'!")

func	_physics_process(delta):
	if target != null:
		var	dist = (position - (target.position - Vector2(0, PLAYER_TOP_OFFSET))).length()
		
		if dist > 4 :
			 zoom = zoom.linear_interpolate(Vector2(MOVING_ZOOM, MOVING_ZOOM), ZOOM_LERP)
		elif dist > 100 :
			zoom = zoom.linear_interpolate(Vector2(OUT_OF_BORDER_ZOOM, OUT_OF_BORDER_ZOOM), ZOOM_LERP)
		else :
			zoom = zoom.linear_interpolate(Vector2(IDLE_ZOOM, IDLE_ZOOM), IDLE_ZOOM_LERP)
		
		position = (target.position - Vector2(0, PLAYER_TOP_OFFSET)).linear_interpolate(position, POSITION_LERP_VALUE)
