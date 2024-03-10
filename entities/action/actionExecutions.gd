
const ATTACK_POTENCY = 20
func attack(_battle: Battle, _caster: Actor, targets: Array): 
	var target = targets[0]
	target.updateTickingHealth(ATTACK_POTENCY)
	
func second_wind(_battle: Battle, caster: Actor, _targets: Array): 
	caster.setStamina(caster.maxStamina)

const STANCH_POTENCY = 20
func stanch(_battle: Battle, caster: Actor, _targets: Array): 
	caster.updateTickingHealth(-STANCH_POTENCY)

const ANKLE_SLICE_POTENCY = 40
func ankle_slice(_battle: Battle, _caster: Actor, targets: Array): 
	var target = targets[0]
	target.updateTickingHealth(ATTACK_POTENCY)
	target.updateStamina(-ANKLE_SLICE_POTENCY);

const HEAL_POTENCY = 40
func heal(_battle: Battle, _caster: Actor, targets: Array):
	var target = targets[0] 
	target.updateHealth(HEAL_POTENCY)
	
func drain(_battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	target.updateTickingHealth(ATTACK_POTENCY)
	caster.updateHealth(ATTACK_POTENCY)
	
const REVENGE_POTENCY = 60
func revenge(_battle: Battle, caster: Actor, targets: Array): 
	var target = targets[0]
	if (caster.getTickingHealth() == caster.getHealth()):
		target.updateTickingHealth(REVENGE_POTENCY)
	else:
		target.updateTickingHealth(ATTACK_POTENCY)

func sweep(_battle: Battle, _caster: Actor, targets: Array): 
	for target in targets:
		target.updateTickingHealth(ATTACK_POTENCY)

func assault(_battle: Battle, caster: Actor, targets: Array):
	var target = targets[0]
	target.updateTickingHealth(ANKLE_SLICE_POTENCY)
	caster.updateTickingHealth(caster.getTickingHealth()+ATTACK_POTENCY);
	
func exert(_battle: Battle, caster: Actor, targets: Array):
	var target = targets[0]
	caster.updateStamina(0)
	target.updateTickingHealth(target.getTickingHealth()+3);
	
func shadow_strike(_battle: Battle, _caster: Actor, targets: Array):
	# need to figure out how to apply and convey traits on magic attacks
	var target = targets[0]
	target.updateTickingHealth(ATTACK_POTENCY)
	target.updateTickingHealth(ATTACK_POTENCY);
	
func erupt(_battle: Battle, _caster: Actor, targets: Array): 
	for target in targets:
		target.updateTickingHealth(ATTACK_POTENCY)
