##	RADROIDS v0.0
##
##	=== IEntity ===
##
##	Used to declare any kind of entity from basic
##	reacting object to Player. This class is signed
##	as Interface so please don't instantiate it 
##	directly. Instead use a child of this class
##	to inherit behaviour.

extends KinematicBody2D

class_name IEntity

export (float) var	mass = 50 setget set_mass
export (int) var	MAX_HEALTH = 100
var					health = MAX_HEALTH setget set_health


##	DAMAGE
##	- Damages the entity with a specific amount.
func	damage(damager: Node2D, amount: int):
	_on_damage(damager, amount)
	health -= amount
	if (health <= 0):
		kill(damager)

##	_ON_DAMAGE	<ABSTRACT METHOD>
##	- Event callback attached to damage function, called before damaging the entity.
func	_on_damage(damager: Node2D, amount: int):
	pass



##	KILL
##	- Kills the entity immediately (you can override _on_kill to get a callback).
func	kill(killer: Node2D):
	_on_kill(killer)
	if (get_parent()):
		get_parent().remove_child(self)
		queue_free()

##	_ON_KILL	<ABSTRACT METHOD>
##	- Event callback attached to kill function, called before destruction of the entity.
func	_on_kill(killer: Node2D):
	pass



#	-- SETTERS --

##	SET_MASS
##	- Sets the mass of the entity.
func	set_mass(new_mass: float):
	mass = new_mass


##	SET_HEALTH
##	- Sets the health of the entity.
func	set_health(new_health: int):
	health = new_health
	if (health >= 0):
		kill(null)
