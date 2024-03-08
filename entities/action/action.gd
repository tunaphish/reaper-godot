class_name Action extends Resource

enum TargetType {
	SELF,
	SINGLE,
	AOE,
	ALL
	# Multi Target? Select Target multiple times.. 
}

export (String) var name
export (String) var description
export (int) var staminaCost
export (int) var magicCost
export (TargetType) var targetType

func get_execution_name():
	return name.to_lower().replace(' ', '_')
