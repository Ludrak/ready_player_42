extends Camera2D

const		POSITION_LERP_VALUE = 0.94
const		IDLE_ZOOM_LERP = 0.01
const		ZOOM_LERP = 0.03

const		IDLE_ZOOM = 1.1
const		MOVING_ZOOM = 1.9
const		OUT_OF_BORDER_ZOOM = 2.5

const		PLAYER_TOP_OFFSET = 100

onready var	player = get_parent().get_node("Player")

func	_ready():
	set_physics_process(true);

func	_physics_process(delta):
	var	dist = (self.position - (player.position - Vector2(0, PLAYER_TOP_OFFSET))).length()
	if dist > 4 :
		 self.zoom = self.zoom.linear_interpolate(Vector2(MOVING_ZOOM, MOVING_ZOOM), ZOOM_LERP)
	elif dist > 100 :
		self.zoom = self.zoom.linear_interpolate(Vector2(OUT_OF_BORDER_ZOOM, OUT_OF_BORDER_ZOOM), ZOOM_LERP)
	else :
		self.zoom = self.zoom.linear_interpolate(Vector2(IDLE_ZOOM, IDLE_ZOOM), IDLE_ZOOM_LERP)

	self.position = (player.position - Vector2(0, PLAYER_TOP_OFFSET)).linear_interpolate(self.position, POSITION_LERP_VALUE)
	
	
	
