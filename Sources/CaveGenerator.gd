extends Node2D

## DEVELOPPEMENT STAGE
const		DEV_SEED = 563
const		MAP_X = 20
const		MAP_Y = 5

var			noise_val = 0

const		CHUNK_NUM = 4

onready var	chunks_ = preload("res://Sources/Chunk.gd")
onready var	chunks = []


func	_ready():
	randomize()
	var s = rand_range(0, 100000000)
	for i in range(CHUNK_NUM) :
		var	chunk = Chunk.new(self);
		chunk.generate (s, noise_val, i * 16);
		chunks.append(Chunk.new(self))
		noise_val += 16
		
	# = Chunk.new(self)
	#chunks.generate(3, noise_val, 0)
	#noise_val += 16
	
	set_process(true)

func	_process(delta):
	for chunk in chunks :
		chunk.update_chunk(delta)
	pass
	


	
