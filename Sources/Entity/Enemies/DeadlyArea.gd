extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("'", name, "' entered the scene!")

func _on_body_entered(body):
	print("'", body.name, "' touched '", name, "'!")
	if body.has_method("kill"):
		body.kill(self)
