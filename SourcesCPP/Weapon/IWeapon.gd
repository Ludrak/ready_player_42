##  RADROIDS v0.0
##
##  == IWeapon ==
##
##

extends Node2D

class_name IWeapon

export (int) var            WEAPON_COOLDOWN = 10
export (int) var            RECOIL_AMOUNT = 100
var                         current_recoil = 0
var                         has_recoil = true

export (PackedScene) var    bullet
var                         shooter

##  CAN_SHOOT   <ABSTRACT METHOD>
##  - Use this to know if that weapon can shoot at any time
func can_shoot():
	pass



##  SHOOT
##  - Use this to shoot
func shoot(target: Vector2):
	if (can_shoot()):
		_on_shoot(target)
		#shoot
		pass



##  _ON_SHOOT   <ABSTRACT METHOD>
##  - Override this in child to get shoot event
func _on_shoot(target: Vector2):
	pass
