extends PanelContainer

var memberEntity: Member

func _ready():
	if (!memberEntity):
		memberEntity = load("res://entities/member/aubrey/aubrey.tres")
	var avatarButton = $"AvatarButton"
	avatarButton.texture_normal = memberEntity.avatar
	var healthBar = $"Resources/HealthBar"
	healthBar.max_value = memberEntity.maxHealth
	healthBar.value = memberEntity.health
	memberEntity.connect("healthUpdated", self, "_on_memberEntity_healthUpdated")
	
	var staminaBar = $"Resources/StaminaBar"
	staminaBar.max_value = memberEntity.maxStamina
	staminaBar.value = memberEntity.stamina
	memberEntity.connect("staminaUpdated", self, "_on_memberEntity_staminaUpdated")

	var magicBar = $"Resources/MagicBar"
	magicBar.max_value = memberEntity.maxMagic
	magicBar.value = memberEntity.magic
	memberEntity.connect("magicUpdated", self, "_on_memberEntity_magicUpdated")

func _on_memberEntity_healthUpdated():
	$"Resources/HealthBar".value = memberEntity.health

func _on_memberEntity_staminaUpdated():
	$"Resources/StaminaBar".value = memberEntity.stamina

func _on_memberEntity_magicUpdated():
	$"Resources/MagicBar".value = memberEntity.magic

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
