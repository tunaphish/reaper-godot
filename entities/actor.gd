tool
class_name Actor extends Resource

enum State {
	NORMAL,
	DEAD,
	EXHAUSTED,
	GUARD,
	CASTING, 
	ATTACKING, 
} 

# max values set to 10000000 due to initialization bug with clamp and internal references, not Inf because those are floats
export(String) var name
export(int) var health setget setHealth, getHealth
export(int) var maxHealth = 1000000
export(int) var tickingHealth setget setTickingHealth, getTickingHealth
export(int) var stamina setget setStamina, getStamina
export(int) var maxStamina = 1000000
export(int) var staminaRegenRate
export(int) var magic setget setMagic, getMagic
export(int) var maxMagic = 1000000
export(State) var state  = State.NORMAL setget setState, getState 
export(Resource) var queuedAction setget setQueuedAction, getQueuedAction

export(Resource) var folder

signal healthUpdated(value)
signal tickingHealthUpdated(value);
signal staminaUpdated(value)
signal magicUpdated(value)
signal healthTicked()
signal stateSet(value)

func setHealth(value):
	health = clamp(value, 0, maxHealth)
	
func getHealth():
	return health
	
func getTickingHealth():
	return tickingHealth
	
func updateHealth(value):
	setHealth(value+getHealth())
	emit_signal("healthUpdated", value)

func setTickingHealth(value):
	tickingHealth = clamp(value, 0, maxHealth)

func updateTickingHealth(value):
	if value > 0 and state == State.GUARD:
		updateStamina(-value)
		emit_signal("staminaUpdated", value)
		return
	if value > 0 and state == State.EXHAUSTED:
		value *= 2
	var newTickingHealth = value+getTickingHealth()
	setTickingHealth(newTickingHealth)
	emit_signal("tickingHealthUpdated", value)
	if newTickingHealth > getHealth():
		updateHealth(-(newTickingHealth-health)) 


const GLOBAL_TICK_RATE = 2
func tickHealth():
	var tick = min(GLOBAL_TICK_RATE, tickingHealth)
	tickingHealth = clamp(tickingHealth-tick, 0, maxHealth)
	health = clamp(health-tick, 0, maxHealth)
	emit_signal("healthTicked")
	
func setStamina(value):
	stamina = clamp(value, -1000000, maxStamina)

func getStamina():
	return stamina

func updateStamina(value):
	setStamina(value+getStamina())
	emit_signal("staminaUpdated", value)

func setMagic(value):
	magic = clamp(value, 0, maxMagic)
	

func getMagic():
	return magic

func updateMagic(value):
	setMagic(value+getMagic())
	emit_signal("magicUpdated", value)
	
func execute_action(action: Action):
	setStamina(getStamina()-action.staminaCost)
	setMagic(getMagic()-action.magicCost)

func setState(value: int): # State as enums can't be used as types...
	state = value
	emit_signal("stateSet", value)

func getState():
	return state

func getQueuedAction():
	return queuedAction

signal actionQueued()
func setQueuedAction(action: Resource):
	queuedAction = action 
	emit_signal("actionQueued")