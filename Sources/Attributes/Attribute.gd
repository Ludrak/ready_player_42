extends Node

signal amount_changed(new_amount)

export (float) var amount = 0 setget set_amount, get_amount

func set_amount(new_amount):
	amount = new_amount

func get_amount():
	return amount

func _ready():
	print("'", name, "' entered the scene!")

