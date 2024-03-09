extends PanelContainer

var enemyEntity: Enemy
const Resources = preload("res://features/battle/visual/Resources.tscn")

func setup(initEnemyEntity: Enemy):
	enemyEntity = initEnemyEntity
	return self

func _ready():
	var avatarButton = $AvatarButton
	avatarButton.texture_normal = enemyEntity.sprite
	var resources = Resources.instance().setup(enemyEntity)
	avatarButton.add_child(resources)
