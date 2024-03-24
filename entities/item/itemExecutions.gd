#var State = preload("res://entities/actor.gd").State

const HEAL_POTENCY = 20
func potion(_caster: Actor, target: Actor, _metadata: Dictionary): 
	target.updateHealth(HEAL_POTENCY)
	
const BOMB_POTENCY = 20
func bomb(_caster: Actor, target: Actor, _metadata: Dictionary): 
	target.receiveDamage(BOMB_POTENCY)