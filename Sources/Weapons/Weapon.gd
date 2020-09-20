extends Node2D

const Cooldown = preload("res://Sources/Cooldown.gd")

export (int) var bullet_count = 10
export (int) var bullet_range = 10000
export (bool) var enabled = false setget set_enabled
export (int) var shoot_cooldown_ms = 500

onready var shoot_cooldown = Cooldown.new(shoot_cooldown_ms / 1000.0)

func _on_enabled(_new_enabled):
	pass

func _on_shoot(_target):
	pass

func set_enabled(new_enabled):
	enabled = new_enabled
	_on_enabled(enabled)

func can_shoot():
	var bullets_left = bullet_count == -1 or bullet_count > 0
	return bullets_left and shoot_cooldown.is_ready()

func shoot(target):
	if enabled and can_shoot():
		_on_shoot(target)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("'", name, "' entered the scene!")

func _process(delta):
	if enabled:
		shoot_cooldown.tick(delta)
