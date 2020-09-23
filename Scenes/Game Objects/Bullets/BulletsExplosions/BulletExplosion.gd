extends Node2D

var timeout = 10

func _process(delta):
	timeout -= delta * 10;
	if (timeout <= 0):
		get_parent().remove_child(self)
		queue_free()
