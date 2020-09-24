extends Area2D

onready var	spawn_point = self.get_parent().get_node("SpawnPoint").position

func _ready():
	connect("body_entered", self, "on_collision")

func _process(delta):
	self.position = Vector2(self.get_parent().get_node("Player").position.x, self.position.y);
	pass # Replace with function body.
	
func on_collision(value):
	print ("Player fallen in the buildings")
	#value.queue_free()
	#value.set_position(spawn_point.position)
