class_name Action extends Resource

const State = preload("res://entities/actor.gd").State

enum TargetType {
	SELF,
	SINGLE,
	AOE,
	ALL
}

export (String) var name
export (String) var description
export (int) var staminaCost
export (int) var magicCost
export (TargetType) var targetType
export (Resource) var sound
export (int) var castTimeInMs = 2000
export (State) var queueState = State.CASTING

func get_execution_name():
	return name.to_lower().replace(' ', '_')
