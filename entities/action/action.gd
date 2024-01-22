class_name Action extends Resource

export (String) var name
export (String) var description
export (int) var staminaCost
export (int) var magicCost

func trigger_action(battleEntity: Battle, caster: Actor, targets: Array) -> void:
	print("base action triggered")
	pass 
