extends KinematicBody2D

enum {IDLE, ATTACK}

#export (int) var	jump_speed = 400
export (int) var gravity = 100
export (int) var idle_speed = 100
export (int) var attack_speed = 200
export (int) var fov = 90
export (int) var view_distance = 1000

onready var enemy = get_parent().get_node("Player") setget set_enemy

var velocity = Vector2.ZERO
var direction = Vector2(1, 1)
var target = null

var state = IDLE

const flip_vector = Vector2(-1, 1)

func set_enemy(new_enemy):
	enemy = new_enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	print("'", name, "' entered the scene!")

func flip():
	direction *= flip_vector
	$FloorRayCast.cast_to *= flip_vector
	$Sprite.flip_h = !$Sprite.flip_h

# TODO: Optimization
func _process(delta):
	target = null
	state = IDLE
	if enemy != null:
		var enemy_player = enemy.transform.origin - transform.origin
		if enemy_player.length() < view_distance:
			if acos(enemy_player.normalized().dot(Vector2(direction.x, 0))) < deg2rad(fov):
				$PlayerRayCast.cast_to = enemy_player
				if $PlayerRayCast.is_colliding():
					target = enemy
					state = ATTACK

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity

	# Handle behaviour
	if state == IDLE:
		if !$FloorRayCast.is_colliding():
			flip()
		velocity.x = direction.x * idle_speed
	elif state == ATTACK:
		if !$FloorRayCast.is_colliding():
			velocity.x = 0
		else:
			velocity.x = direction.x * attack_speed

	# Perform movement
	velocity = move_and_slide(velocity, Vector2(0, -1))
