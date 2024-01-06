tool
class_name Actor extends Resource

export(String) var name
export(int) var health setget setHealth, getHealth
export(int) var maxHealth
export(int) var stamina
export(int) var maxStamina

func _init(initName = 'null', initHealth = 0, initMaxHealth = 0, initStamina = 0, initMaxStamina = 0):
	name = initName
	health = initHealth
	maxHealth = initMaxHealth
	stamina = initStamina
	maxStamina = initMaxStamina

func setHealth(value):
	print(value)
	health = clamp(value, 0, maxHealth)
	
func getHealth():
	return health
	
