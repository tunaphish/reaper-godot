
const ATTACK_POTENCY = 1
func attack(battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	target.setHealth(target.getHealth()-ATTACK_POTENCY)
	
func second_wind(battle: Battle, caster: Actor, targets: Array): 
	caster.setStamina(caster.maxStamina)
	pass

const STANCH_POTENCY = 1
func stanch(battle: Battle, caster: Actor, targets: Array): 
	caster.setTickingHealth(caster.getTickingHealth()-STANCH_POTENCY)

const ANKLE_SLICE_POTENCY = 2
func ankle_slice(battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	target.setHealth(target.getHealth()-ATTACK_POTENCY)
	target.setStamina(target.getStamina-ANKLE_SLICE_POTENCY);

const HEAL_POTENCY = 2
func heal(battle: Battle, caster: Actor, targets: Array):
	var target = targets[0] 
	target.setHealth(target.getHealth()+HEAL_POTENCY)
	
func drain(battle: Battle, caster: Actor, targets: Array): 
	# need to update this for combos and overall damage dealt, 
	# might need to be passed context?
	var target = targets[0]
	target.setHealth(target.getHealth()-ATTACK_POTENCY)
	caster.setHealth(caster.getHealth+ATTACK_POTENCY)
	
const REVENGE_POTENCY = 3
func revenge(battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	if (caster.getTickingHealth() == caster.getHealth()):
		target.setHealth(target.getHealth()-REVENGE_POTENCY)
	else:
		target.setHealth(target.getHealth()-ATTACK_POTENCY)
