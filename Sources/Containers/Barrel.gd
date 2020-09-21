extends RigidBody2D

export (PackedScene) var loot = preload("res://Scenes/Game Objects/Loot/Loot.tscn")

export (int) var		loot_count = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	print("'", name, "' entered the scene!")

func kill(killer: Node):
	print("'", name, "' was killed by '", killer.name, "'!")
	queue_free()
	for i in range (loot_count) :
		var drop = loot.instance()
		drop.position = position
		print ("Dropping '", drop.name, "'!")
		get_parent().call_deferred('add_child', drop)
		if (drop.has_method("add_force")):
			drop.add_force(Vector2(1, 1),  Vector2(rand_range(-2000, 2000), rand_range(-20, 20)))
