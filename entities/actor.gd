tool
class_name Actor extends Resource

# max values set to 10000000 due to initialization bug with clamp and internal references
export(String) var name
export(int) var health setget setHealth, getHealth
export(int) var maxHealth = 1000000
export(int) var tickingHealth setget setTickingHealth, getTickingHealth
export(int) var stamina setget setStamina, getStamina
export(int) var maxStamina = 1000000
export(int) var staminaRegenRate
export(int) var magic setget setMagic, getMagic
export(int) var maxMagic = 1000000

export(Array, Resource) var actions

signal healthUpdated()
signal tickingHealthUpdated();
signal staminaUpdated()
signal magicUpdated()
signal healthTicked()

func setHealth(value):
	health = clamp(value, 0, maxHealth)
	emit_signal("healthUpdated")
	
func getHealth():
	return health
	
func getTickingHealth():
	return tickingHealth
	
func setTickingHealth(value):
	tickingHealth = clamp(value, 0, maxHealth)
	emit_signal("tickingHealthUpdated")

const GLOBAL_TICK_RATE = 1
func tickHealth():
	tickingHealth = clamp(tickingHealth-min(GLOBAL_TICK_RATE, tickingHealth), 0, maxHealth)
	health = clamp(health-min(GLOBAL_TICK_RATE, tickingHealth), 0, maxHealth)
	emit_signal("healthTicked")
	
func setStamina(value):
	stamina = clamp(value, -1000000, maxStamina)
	emit_signal("staminaUpdated")

func getStamina():
	return stamina

func setMagic(value):
	magic = clamp(value, 0, maxMagic)
	emit_signal("magicUpdated")

func getMagic():
	return magic
	
func execute_action(action: Action):
	setStamina(getStamina()-action.staminaCost)
	setMagic(getMagic()-action.magicCost)
	if action.magicCost > magic:
		setHealth(getHealth()-(magic-action.magicCost))

	pass
