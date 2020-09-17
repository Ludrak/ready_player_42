extends Area2D

export (PackedScene) var attribute_decorator = preload("res://Scenes/Game Objects/Attributes/AttributeDecorator.tscn") 
export (int) var decorator_amount = 1
export (String) var attribute = null

# Called when the node enters the scene tree for the first time.
func _ready():
	print("'", name, "' entered the scene!")

func _on_body_entered(body):
	queue_free()
	if attribute != null:
		if body.get("attributes") != null:
			var decorator = attribute_decorator.instance()
			decorator.decoratee = body.attributes.get(attribute)
			decorator.amount = decorator_amount
			body.add_child(decorator)
			body.attributes.set(attribute, decorator)
		else:
			print("Warning: '", body.name, "' does not have attributes!")
