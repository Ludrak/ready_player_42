extends Node2D

class_name Chunk 

#Chunk generation constants
const	HEIGHT = 16
const	WIDTH = 16

## GENERATION
const	MAX_TERRAIN_HEIGHT = 16;
const	MIN_TERRAIN_HEIGHT = 5;

## NOISE
const	NOISE_OCTAVES = 4
const	NOISE_PERIOD = 20
const	NOISE_PERSISTANCE = 0.8

var		parent = null

var		tiles = []

## Constructor
func	_init(p) :
	parent = p
	pass
	
func	map(value, istart, istop, ostart, ostop) :
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))

## Call this every frame to update the chunk position
func	update_chunk(delta):
	for tile in tiles :
		tile.global_position = Vector2(tile.global_position.x - 10, tile.global_position.y)



## Used to generate a whole chunk.
## It requires the same arguments as the generate_column() function.
func	generate(noise_seed, value, x):
	for col_x in range(WIDTH) :
		generate_column(noise_seed, value + col_x, x + col_x)

## Used to generate a single column for one chunk.
## It requires the noise seed, the noise value and the x position of the column
func	generate_column(noise_seed , value, x):
	var noise = OpenSimplexNoise.new()
	var h = 0
	noise.seed = noise_seed
	noise.octaves = NOISE_OCTAVES
	noise.period = NOISE_PERIOD
	noise.persistence = NOISE_PERSISTANCE
	h = noise.get_noise_2d(value, 0)
	h = map(h, 0, 1, MIN_TERRAIN_HEIGHT, MAX_TERRAIN_HEIGHT)
	for y in range (MAX_TERRAIN_HEIGHT) :
		if (MAX_TERRAIN_HEIGHT - y < h) :
				var	block_tile = preload("res://Scenes/Game Objects/Tiles/BlockTile.tscn").instance()
				block_tile.global_position = Vector2(
					x * block_tile.get_node("StaticBody2D/Sprite").scale.x * block_tile.get_node("StaticBody2D/Sprite").get_rect().size.x, 
					y * block_tile.get_node("StaticBody2D/Sprite").scale.y * block_tile.get_node("StaticBody2D/Sprite").get_rect().size.y)
				tiles.append(block_tile)
				parent.add_child(block_tile)
