class_name Item extends Option

const TargetType = preload("res://entities/targetType.gd").TargetType

export(String) var description
export (TargetType) var targetType
export (Resource) var sound
export (int) var maxCharges = 3
export (int) var charges = 1 

func get_execution_name():
	return name.to_lower().replace(' ', '_')
