class_name Action extends Resource

enum TargetType {
	SELF,
	SINGLE,
	AOE,
	ALL
	# Multi Target? Select Target multiple times... 
	# Maybe it can replace AOE 
}

export (String) var name
export (String) var description
export (int) var staminaCost
export (int) var magicCost
export (TargetType) var targetType
export (Resource) var sound
export (int) var castTimeInMs = 1000

func get_execution_name():
	return name.to_lower().replace(' ', '_')
