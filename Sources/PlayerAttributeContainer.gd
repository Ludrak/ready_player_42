extends Node

signal max_jumps_changed

onready var max_jumps = $MaxJumps setget set_max_jumps

func set_max_jumps(new_max_jumps):
	max_jumps = new_max_jumps
	emit_signal("max_jumps_changed", max_jumps.amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
