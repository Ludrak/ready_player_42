extends RigidBody2D

export (PackedScene) var loot = preload("res://Scenes/Game Objects/Loot/Loot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("'", name, "' entered the scene!")

func kill(killer: Node):
	print("'", name, "' was killed by '", killer.name, "'!")
	queue_free()
	var drop = loot.instance()
	drop.position = position
	print("Dropping '", drop.name, "'!")
	get_parent().add_child(drop)
