extends Camera2D
const		NOISE_VAL = 100

const		POSITION_LERP_VALUE = 0.94
const		IDLE_ZOOM_LERP = 0.01
const		ZOOM_LERP = 0.03

const		IDLE_ZOOM = 1.2
const		MOVING_ZOOM = 1.4
const		OUT_OF_BORDER_ZOOM = 2

const		PLAYER_TOP_OFFSET = 300

onready var target setget set_target

func	_ready():
	set_target(self.get_parent().get_node("Player"))

func	set_target(new_target):
	target = new_target
	print("Camera target changed to '", target.name, "'")

var x_noise = 0;
var	y_noise = 0;
func	_physics_process(delta):
	var	dist = (position - (target.position - Vector2(0, PLAYER_TOP_OFFSET))).length()
	
	if dist > NOISE_VAL :
		 zoom = zoom.linear_interpolate(Vector2(MOVING_ZOOM, MOVING_ZOOM), ZOOM_LERP)
	elif dist > 140 :
		zoom = zoom.linear_interpolate(Vector2(OUT_OF_BORDER_ZOOM, OUT_OF_BORDER_ZOOM), ZOOM_LERP)
	else :
		zoom = zoom.linear_interpolate(Vector2(IDLE_ZOOM, IDLE_ZOOM), IDLE_ZOOM_LERP)
		
	var noise = OpenSimplexNoise.new()
	noise.seed = 4242342
	noise.octaves = 1
	noise.period = 20
	noise.persistence = 0.8
	position = (target.position - Vector2(0, PLAYER_TOP_OFFSET) + Vector2(noise.get_noise_2d(x_noise, 0) * NOISE_VAL, noise.get_noise_2d(0, y_noise) * NOISE_VAL)).linear_interpolate(position, POSITION_LERP_VALUE)
	x_noise += 0.1
	y_noise += 0.1
