extends PanelContainer

var enemyEntity: Enemy

func _ready():
	if (!enemyEntity):
		enemyEntity = load("res://entities/enemy/boss/boss.tres")
	var avatarButton = $AvatarButton
	avatarButton.texture_normal = enemyEntity.sprite
	var healthBar = $Resources/HealthBar
	healthBar.max_value = enemyEntity.maxHealth
	healthBar.value = enemyEntity.health
	enemyEntity.connect("healthUpdated", self, "_on_enemyEntity_healthUpdated")
	
	var staminaBar = $Resources/StaminaBar
	staminaBar.max_value = enemyEntity.maxStamina
	staminaBar.value = enemyEntity.stamina
	enemyEntity.connect("staminaUpdated", self, "_on_enemyEntity_staminaUpdated")

	var magicBar = $Resources/MagicBar
	magicBar.max_value = enemyEntity.maxMagic
	magicBar.value = enemyEntity.magic
	enemyEntity.connect("magicUpdated", self, "_on_enemyEntity_magicUpdated")

func _on_enemyEntity_healthUpdated():
	$Resources/HealthBar.value = enemyEntity.health

func _on_enemyEntity_staminaUpdated():
	$Resources/StaminaBar.value = enemyEntity.stamina

func _on_enemyEntity_magicUpdated():
	$Resources/MagicBar.value = enemyEntity.magic
