extends PanelContainer

var enemy: Enemy
const Resources = preload("res://features/battle/visual/Resources.tscn")
onready var vstack = $VStack
onready var nameLabel = $VStack/Name

func setup(initEnemy: Enemy):
	enemy = initEnemy
	return self

func _ready():
	nameLabel.text = enemy.name
	var resources = Resources.instance().setup(enemy)
	vstack.add_child(resources)
