extends Node2D

export (PackedScene) var max_jumps_decorator = preload("res://Scenes/Game Objects/Attributes/MaxJumpsDecorator.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Entered 'Main' scene!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PowerUp_body_entered(_body):
	call_deferred("remove_child", $PowerUp)
	var attributes = $Player/Attributes
	var decorator = max_jumps_decorator.instance()
	decorator.decoratee = attributes.max_jumps
	decorator.amount = 2
	add_child(decorator)
	attributes.max_jumps = decorator
	
