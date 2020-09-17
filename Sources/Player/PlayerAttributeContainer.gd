extends Node

#signal max_jumps_changed
#signal coin_multiplicator_changed

onready var max_jumps = $MaxJumps setget set_max_jumps
onready var coin_multiplicator = $CoinMultiplicator setget set_coin_multiplicator

func set_max_jumps(new_max_jumps):
	max_jumps = new_max_jumps
#	emit_signal("max_jumps_changed", max_jumps.amount)

func set_coin_multiplicator(new_coin_multiplicator):
	coin_multiplicator = new_coin_multiplicator
#	emit_signal("coin_multiplicator_changed", coin_multiplicator.amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
