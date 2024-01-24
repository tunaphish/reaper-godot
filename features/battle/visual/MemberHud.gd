extends PanelContainer

var memberEntity: Member
var actionExections = preload("res://entities/action/actionExecutions.gd").new()

func _ready():
	if (!memberEntity):
		memberEntity = load("res://entities/member/aubrey/aubrey.tres")
	var healthBar = $AvatarButton/Resources/HealthBar
	healthBar.max_value = memberEntity.maxHealth
	healthBar.value = memberEntity.health
	memberEntity.connect("healthUpdated", self, "_on_memberEntity_healthUpdated")
	
	var staminaBar = $AvatarButton/Resources/StaminaBar
	staminaBar.max_value = memberEntity.maxStamina
	staminaBar.value = memberEntity.stamina
	memberEntity.connect("staminaUpdated", self, "_on_memberEntity_staminaUpdated")

	var magicBar = $AvatarButton/Resources/MagicBar
	magicBar.max_value = memberEntity.maxMagic
	magicBar.value = memberEntity.magic
	memberEntity.connect("magicUpdated", self, "_on_memberEntity_magicUpdated")
	
	var avatarButton = $AvatarButton
	avatarButton.texture_normal = memberEntity.avatar
	avatarButton.connect("pressed", self, "_on_avatarButton_pressed")
	
func _on_avatarButton_pressed():
	for action in memberEntity.actions:
		var actionExecution = action.get_execution_name()
		#actionExections.call(actionExecution)

func _on_memberEntity_healthUpdated():
	$AvatarButton/Resources/HealthBar.value = memberEntity.health

func _on_memberEntity_staminaUpdated():
	$AvatarButton/Resources/StaminaBar.value = memberEntity.stamina

func _on_memberEntity_magicUpdated():
	$AvatarButton/Resources/MagicBar.value = memberEntity.magic
