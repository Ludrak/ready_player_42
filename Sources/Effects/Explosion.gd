tool

extends Node2D

export (int) var	explosion_force = 80

export (bool) var	exploding = false setget set_exploding

func	_ready():
	explode()

func	set_exploding(new_exploding):
	exploding = new_exploding;
	if (exploding):
		explode();
		exploding = false
		
func	explode():
	$Smoke.emitting = true
	$NewFire.emitting = true
	$DamageZoneIndicator.emitting =true
	$Sparkles.emitting = true
	var	cam = get_viewport().get_camera()
	if (cam && cam.has_method("set_shaking")):
		cam.set_shaking(true);
	yield(get_tree().create_timer(0.2),"timeout")
	kill_around()
	
func	kill_around():
	for body in $DamageArea.get_overlapping_bodies() :
		if (body.has_method("damage")):
			body.damage(self, explosion_force)
		elif (body.has_method("kill")):
			body.kill(self)
	
