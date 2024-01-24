tool
class_name Actor extends Resource

export(String) var name
export(int) var health setget setHealth, getHealth
export(int) var maxHealth = INF
export(int) var tickingHealth setget setTickingHealth, getTickingHealth
export(int) var stamina setget setStamina, getStamina
export(int) var maxStamina = INF
export(int) var staminaRegenRate
export(int) var magic setget setMagic, getMagic
export(int) var maxMagic = INF

export(Array, Resource) var actions

signal healthUpdated()
signal tickingHealthUpdated();
signal staminaUpdated()
signal magicUpdated()

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
	
func setStamina(value):
	stamina = clamp(value, -INF, maxStamina)
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
	# TODO drain health if no magic available
	pass
