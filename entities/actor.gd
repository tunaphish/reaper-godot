tool
class_name Actor extends Resource

export(String) var name
export(int) var health setget setHealth, getHealth
export(int) var maxHealth = INF
export(int) var stamina setget setStamina, getStamina
export(int) var maxStamina = INF
export(int) var magic setget setMagic, getMagic
export(int) var maxMagic = INF

signal healthUpdated()
signal staminaUpdated()
signal magicUpdated()

func setHealth(value):
	health = clamp(value, 0, maxHealth)
	emit_signal("healthUpdated")
	
func getHealth():
	return health
	
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
