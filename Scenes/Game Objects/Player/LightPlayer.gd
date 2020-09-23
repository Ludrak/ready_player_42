extends Light2D

const		noise_strength = 1000;
const		noise_speed = 0.1

var			noise_val_x = 0
var			noise_val_y = 0
var			fixed_pos;

# Called when the node enters the scene tree for the first time.
func _ready():
	fixed_pos = Vector2(position.x, position.y)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var noise = OpenSimplexNoise.new()

	noise.seed = 38298;
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
	position = fixed_pos + Vector2(noise.get_noise_2d(noise_val_x, 0.0), noise.get_noise_2d(0.0, noise_val_y)) * noise_strength * delta
	noise_val_x += noise_speed
	noise_val_y += noise_speed
	pass
