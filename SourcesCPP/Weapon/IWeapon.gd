##  RADROIDS v0.0
##
##  == IWeapon ==
##
##

extends Node2D

class_name IWeapon

const						Cooldown = preload("res://Sources/Cooldown.gd")
var							shoot_cooldown_ms = 250
onready var					shoot_cooldown = Cooldown.new(shoot_cooldown_ms / 1000.0)

export (bool) var			enabled = false setget set_enabled
export (int) var            WEAPON_COOLDOWN = 10
export (int) var            RECOIL_AMOUNT = 100
var                         current_recoil = 0
var                         has_recoil = true

export (PackedScene) var    bullet
var                         shooter setget set_shooter

##  CAN_SHOOT   <ABSTRACT METHOD>
##  - Use this to know if that weapon can shoot at any time
func can_shoot():
	return (shoot_cooldown.is_ready())



##  SHOOT
##  - Use this to shoot
func shoot(target: Vector2):
	if (can_shoot()):
		_on_shoot(target)
		#shoot
		pass



##  _ON_SHOOT   <ABSTRACT METHOD>
##  - Override this in child to get shoot event
func _on_shoot(_target: Vector2):
	pass



##
##
func _on_enabled(_new_enabled):
	pass



##
##
func set_enabled(new_enabled):
	enabled = new_enabled
	_on_enabled(enabled)




##
##
func set_shooter(new_shooter : IPlayerEntity):
	shooter = new_shooter




func	_process(delta):
	if (enabled):
		shoot_cooldown.tick(delta)
