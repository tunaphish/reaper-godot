var State = preload("res://entities/actor.gd").State

const ATTACK_POTENCY = 20
func attack(_battle: Battle, _caster: Actor, targets: Array): 
	var target = targets[0]
	target.receiveDamage(ATTACK_POTENCY)
	
func second_wind(_battle: Battle, caster: Actor, _targets: Array): 
	caster.setStamina(caster.maxStamina)

const STANCH_POTENCY = 20
func stanch(_battle: Battle, caster: Actor, _targets: Array): 
	caster.receiveDamage(-STANCH_POTENCY)

const ANKLE_SLICE_POTENCY = 40
func ankle_slice(_battle: Battle, _caster: Actor, targets: Array): 
	var target = targets[0]
	target.receiveDamage(ATTACK_POTENCY)
	target.updateStamina(-ANKLE_SLICE_POTENCY);

const HEAL_POTENCY = 40
func heal(_battle: Battle, _caster: Actor, targets: Array):
	var target = targets[0] 
	target.updateHealth(HEAL_POTENCY)
	
func drain(_battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	target.receiveDamage(ATTACK_POTENCY)
	caster.updateHealth(ATTACK_POTENCY)
	
const REVENGE_POTENCY = 60
func revenge(_battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	if (caster.getTickingHealth() == caster.getHealth()):
		target.receiveDamage(REVENGE_POTENCY)
	else:
		target.receiveDamage(ATTACK_POTENCY)

func sweep(_battle: Battle, _caster: Actor, targets: Array): 
	for target in targets:
		target.receiveDamage(ATTACK_POTENCY)

func assault(_battle: Battle, caster: Actor, targets: Array):
	var target = targets[0]
	target.receiveDamage(ANKLE_SLICE_POTENCY)
	caster.receiveDamage(caster.getTickingHealth()+ATTACK_POTENCY);
	
func exert(_battle: Battle, caster: Actor, targets: Array):
	var target = targets[0]
	caster.updateStamina(0)
	target.receiveDamage(target.getTickingHealth()+3);
	
func shadow_strike(_battle: Battle, _caster: Actor, targets: Array):
	var target = targets[0]
	target.receiveDamage(ATTACK_POTENCY)
	target.receiveDamage(ATTACK_POTENCY);
	
func erupt(_battle: Battle, _caster: Actor, targets: Array): 
	for target in targets:
		target.receiveDamage(ATTACK_POTENCY)

func guard(_battle: Battle, caster: Actor, _targets: Array): 
	caster.setState(State.GUARD)

func jab(_battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	target.receiveDamage(7)

func haymaker(_battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	target.receiveDamage(50)