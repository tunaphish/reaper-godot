extends PanelContainer

var enemy: Enemy
const Resources = preload("res://features/battle/visual/Resources.tscn")
onready var nameLabel = $Name

func setup(initEnemy: Enemy):
	enemy = initEnemy
	return self

func _ready():
	nameLabel.text = enemy.name
	var resources = Resources.instance().setup(enemy)
	add_child(resources)
