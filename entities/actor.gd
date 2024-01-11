tool
class_name Actor extends Resource

export(String) var name
export(int) var health setget setHealth, getHealth
export(int) var maxHealth = INF
export(int) var stamina setget setStamina, getStamina
export(int) var maxStamina = INF

signal staminaUpdated(actor)

func setHealth(value):
	health = clamp(value, 0, maxHealth)
	
func getHealth():
	return health
	
func setStamina(value):
	if (value > maxStamina):
		stamina = maxStamina
	else: 
		stamina = value
	emit_signal("staminaUpdated", self)

func getStamina():
	return stamina
