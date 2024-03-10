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

export(Resource) var folder

signal healthUpdated(value)
signal tickingHealthUpdated(value);
signal staminaUpdated(value)
signal magicUpdated(value)
signal healthTicked()

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
	setTickingHealth(value+getTickingHealth())
	emit_signal("tickingHealthUpdated", value)

const GLOBAL_TICK_RATE = 1
func tickHealth():
	tickingHealth = clamp(tickingHealth-min(GLOBAL_TICK_RATE, tickingHealth), 0, maxHealth)
	health = clamp(health-min(GLOBAL_TICK_RATE, tickingHealth), 0, maxHealth)
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


# handle health when tick damage is maxed out or not