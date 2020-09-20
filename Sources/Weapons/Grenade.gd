extends RigidBody2D

var target = Vector2.ZERO
var force = Vector2.ZERO

onready var p0 = position
onready var p1 = target - global_position
onready var p2 = (p1 - p0) / 2 + force

var t = 0.0
var duration = 1.0

func _ready():
	print("'", name, "' entered the scene!")

func _process(delta):
	t += delta / duration
	if t <= duration:
		var q0 = p0.linear_interpolate(p2, min(t, 1.0))
		var q1 = p2.linear_interpolate(p1, min(t, 1.0))
		position = q0.linear_interpolate(q1, min(t, 1.0))
	else:
		visible = false
		get_parent().remove_child(self)
		queue_free()


func _on_TriggerArea_body_entered(body):
	visible = false
	print("'", name, "' has been triggered by '", body.name, "'!")
	var victims = $ExplosionArea.get_overlapping_bodies()

	for victim in victims:
		if victim.has_method("kill"):
			victim.kill(self)
	pass # Replace with function body.
