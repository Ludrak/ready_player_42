extends Camera2D
const		NOISE_VAL = 100

const		POSITION_LERP_VALUE = 55.20#0.94
const		IDLE_ZOOM_LERP = 2#0.01
const		ZOOM_LERP = 0.8#0.03

const		IDLE_ZOOM = 1.2
const		MOVING_ZOOM = 1.4
const		OUT_OF_BORDER_ZOOM = 2

const		PLAYER_TOP_OFFSET = 150

var			shake_amount = 1000
var			is_shaking = false setget set_shaking
var			shake_cooldown_ms = 100
var			shake_cooldown = shake_cooldown

onready var target = get_parent().get_node("Player") setget set_target

func	_ready():
	print("'", name, "' entered the scene!")

func	set_target(new_target):
	target = new_target
	print("'", name, "' target changed to '", target.name, "'!")
	
func	_process(_delta):
	if (Input.is_action_pressed("ui_down")):
		top_offset = lerp(top_offset, PLAYER_TOP_OFFSET - 400, 0.5);
	else :
		top_offset = lerp(top_offset, PLAYER_TOP_OFFSET, 0.5)

var x_noise = 0;
var	y_noise = 0;
var	top_offset = PLAYER_TOP_OFFSET
func	_physics_process(delta):
	if (target != null):
		var	dist = (position - (target.position - Vector2(0, PLAYER_TOP_OFFSET))).length()
		
		if dist > NOISE_VAL :
			zoom = zoom.linear_interpolate(Vector2(MOVING_ZOOM, MOVING_ZOOM), ZOOM_LERP * delta)
		elif dist > 140 :
			zoom = zoom.linear_interpolate(Vector2(OUT_OF_BORDER_ZOOM, OUT_OF_BORDER_ZOOM), ZOOM_LERP * delta)
		else :
			zoom = zoom.linear_interpolate(Vector2(IDLE_ZOOM, IDLE_ZOOM), IDLE_ZOOM_LERP * delta)
			
		var noise = OpenSimplexNoise.new()
		noise.seed = 4242342
		noise.octaves = 1
		noise.period = 20
		noise.persistence = 0.8
		position = (target.position - Vector2(0, top_offset) + Vector2(noise.get_noise_2d(x_noise, 0) * NOISE_VAL, noise.get_noise_2d(0, y_noise) * NOISE_VAL)).linear_interpolate(position, POSITION_LERP_VALUE * delta)
		x_noise += 0.1
		y_noise += 0.1
		
		if (is_shaking):
			camera_shake(shake_amount);
			shake_cooldown -= 1
			if (shake_cooldown <= 0):
				is_shaking = false
				shake_cooldown = 0;
		elif (offset != Vector2.ZERO):
			offset = Vector2.ZERO
		
func	set_shaking(new_shaking : bool):
	is_shaking = new_shaking;
	if (new_shaking):
		shake_cooldown = shake_cooldown_ms
		
func	camera_shake(amount : int):
	print ("shaking")
	offset = Vector2(rand_range(-amount/2.0, amount/2.0), rand_range(-amount/2.0, amount/2.0));
