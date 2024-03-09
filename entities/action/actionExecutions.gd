
const ATTACK_POTENCY = 20
func attack(battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	target.setTickingHealth(target.getTickingHealth()+ATTACK_POTENCY)
	
func second_wind(battle: Battle, caster: Actor, targets: Array): 
	caster.setStamina(caster.maxStamina)

const STANCH_POTENCY = 20
func stanch(battle: Battle, caster: Actor, targets: Array): 
	caster.setTickingHealth(caster.getTickingHealth()-STANCH_POTENCY)

const ANKLE_SLICE_POTENCY = 40
func ankle_slice(battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	target.setTickingHealth(target.getTickingHealth()+ATTACK_POTENCY)
	target.setStamina(target.getStamina()-ANKLE_SLICE_POTENCY);

const HEAL_POTENCY = 40
func heal(battle: Battle, caster: Actor, targets: Array):
	var target = targets[0] 
	target.setHealth(target.getHealth()+HEAL_POTENCY)
	
func drain(battle: Battle, caster: Actor, targets: Array): 
	# need to update this for combos and overall damage dealt, 
	# might need to be passed context?
	var target = targets[0]
	target.setTickingHealth(target.getTickingHealth()+ATTACK_POTENCY)
	caster.setHealth(caster.getHealth()+ATTACK_POTENCY)
	
const REVENGE_POTENCY = 60
func revenge(battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	if (caster.getTickingHealth() == caster.getHealth()):
		target.setTickingHealth(target.getTickingHealth()+REVENGE_POTENCY)
	else:
		target.setTickingHealth(target.getTickingHealth()+ATTACK_POTENCY)

func sweep(battle: Battle, caster: Actor, targets: Array): 
	for target in targets:
		target.setTickingHealth(target.getTickingHealth())

func assault(battle: Battle, caster: Actor, targets: Array):
	var target = targets[0]
	target.setTickingHealth(target.getTickingHealth()+20)
	caster.setTickingHealth(caster.getTickingHealth()+10);
	
func exert(battle: Battle, caster: Actor, targets: Array):
	var target = targets[0]
	caster.setStamina(0)
	target.setTickingHealth(target.getTickingHealth()+3);
	
func shadow_strike(battle: Battle, caster: Actor, targets: Array):
	# need to figure out how to apply and convey traits on magic attacks
	var target = targets[0]
	target.setTickingHealth(target.getTickingHealth()+ATTACK_POTENCY)
	target.setTickingHealth(target.getTickingHealth()+ATTACK_POTENCY);
	
func erupt(battle: Battle, caster: Actor, targets: Array): 
	for target in targets:
		target.setTickingHealth(target.getTickingHealth()+ATTACK_POTENCY)
