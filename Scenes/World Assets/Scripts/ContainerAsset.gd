extends StaticBody2D

const	LERP_VAL = 10

var		player_inside = false
var		alpha_ratio = 0
func	_on_InsideArea_body_entered(body):
	player_inside = true
	
func	_on_InsideArea_body_exited(body):
	player_inside = false

	

func	_process(delta):
	if (player_inside) :
		alpha_ratio = 0.0
	else :
		alpha_ratio = 1
	$container_outside.modulate.a = lerp ($container_outside.modulate.a, alpha_ratio, LERP_VAL * delta)


