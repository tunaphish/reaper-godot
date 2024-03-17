var State = preload("res://entities/actor.gd").State

const ATTACK_POTENCY = 20
func attack(_caster: Actor, targets: Array, _metadata: Dictionary): 
	var target = targets[0]
	target.receiveDamage(ATTACK_POTENCY)
	
func second_wind(caster: Actor, _targets: Array, _metadata: Dictionary): 
	caster.setStamina(caster.maxStamina)

const STANCH_POTENCY = 20
func stanch(caster: Actor, _targets: Array, _metadata: Dictionary): 
	caster.receiveDamage(-STANCH_POTENCY)

const ANKLE_SLICE_POTENCY = 40
func ankle_slice(_caster: Actor, targets: Array, _metadata: Dictionary): 
	var target = targets[0]
	target.receiveDamage(ATTACK_POTENCY)
	target.updateStamina(-ANKLE_SLICE_POTENCY);

const HEAL_POTENCY = 40
func heal(_caster: Actor, targets: Array, _metadata: Dictionary):
	var target = targets[0] 
	target.updateHealth(HEAL_POTENCY)
	
func drain(caster: Actor, targets: Array, _metadata: Dictionary): 
	var target = targets[0]
	target.receiveDamage(ATTACK_POTENCY)
	caster.updateHealth(ATTACK_POTENCY)
	
const REVENGE_POTENCY = 60
func revenge(caster: Actor, targets: Array, _metadata: Dictionary): 
	var target = targets[0]
	if (caster.getTickingHealth() == caster.getHealth()):
		target.receiveDamage(REVENGE_POTENCY)
	else:
		target.receiveDamage(ATTACK_POTENCY)

func sweep(_caster: Actor, targets: Array, _metadata: Dictionary): 
	for target in targets:
		target.receiveDamage(ATTACK_POTENCY)

func assault(caster: Actor, targets: Array, _metadata: Dictionary):
	var target = targets[0]
	target.receiveDamage(ANKLE_SLICE_POTENCY)
	caster.receiveDamage(caster.getTickingHealth()+ATTACK_POTENCY);
	
func exert(caster: Actor, targets: Array, _metadata: Dictionary):
	var target = targets[0]
	caster.updateStamina(0)
	target.receiveDamage(target.getTickingHealth()+3);
	
func shadow_strike(_caster: Actor, targets: Array, _metadata: Dictionary):
	var target = targets[0]
	target.receiveDamage(ATTACK_POTENCY)
	target.receiveDamage(ATTACK_POTENCY);
	
func erupt(_caster: Actor, targets: Array, _metadata: Dictionary): 
	for target in targets:
		target.receiveDamage(ATTACK_POTENCY)

func guard(caster: Actor, _targets: Array, _metadata: Dictionary): 
	caster.setState(State.GUARD)

func jab(_caster: Actor, targets: Array, _metadata: Dictionary): 
	var target = targets[0]
	target.receiveDamage(7)

func haymaker(_caster: Actor, targets: Array, _metadata: Dictionary): 
	var target = targets[0]
	target.receiveDamage(50)

func evade(_caster: Actor, _targets: Array, _metadata: Dictionary): 
	return

func counter(caster: Actor, _targets: Array, _metadata: Dictionary): 
	caster.setState(State.COUNTER)

func reflect(caster: Actor, _targets: Array, _metadata: Dictionary): 
	caster.setState(State.REFLECT)

func resurrect(_caster: Actor, targets: Array, _metadata: Dictionary): 
	var target = targets[0]
	if target.state == State.DEAD:
		target.updateHealth(20)

func gloves_up(caster: Actor, targets: Array, _metadata: Dictionary): 
	var target = targets[0]
	target.receiveDamage(ATTACK_POTENCY)
	caster.setState(State.GUARD)
	
const QUICK_DRAW_POTENCY = 60
func quick_draw(_caster: Actor, targets: Array, metadata: Dictionary): 
	var timeInMenu = metadata.get("menuTimer", 0) * 20
	var damage = int(clamp(QUICK_DRAW_POTENCY-timeInMenu, 0, 60))
	var target = targets[0]
	target.receiveDamage(damage)
