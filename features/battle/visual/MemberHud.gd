extends PanelContainer

var memberEntity: Member
var actionExections = preload("res://entities/action/actionExecutions.gd").new()

onready var healthBar = $AvatarButton/Resources/HealthTickingBar/HealthBar
onready var healthLabel = $AvatarButton/Resources/HealthTickingBar/HealthLabel
onready 	var healthTickingBar = $AvatarButton/Resources/HealthTickingBar
onready 	var staminaBar = $AvatarButton/Resources/StaminaBar
onready var staminaLabel = $AvatarButton/Resources/StaminaBar/StaminaLabel
onready 	var magicBar = $AvatarButton/Resources/MagicBar
onready var magicLabel = $AvatarButton/Resources/MagicBar/MagicLabel

const LABEL_FORMAT_STRING = "%s / %s"

const NEGATIVE_STAMINA_COLOR = Color.yellow 
const POSITIVE_STAMINA_COLOR = Color.green
func renderStaminaBar(): 
	staminaBar.value = abs(memberEntity.stamina)
	staminaBar.tint_progress = POSITIVE_STAMINA_COLOR if memberEntity.stamina > 0 else NEGATIVE_STAMINA_COLOR
	staminaLabel.text = LABEL_FORMAT_STRING % [memberEntity.stamina, memberEntity.maxStamina]	

func _ready():
	if (!memberEntity):
		memberEntity = load("res://entities/member/aubrey/aubrey.tres")
		

	healthBar.max_value = memberEntity.maxHealth
	healthBar.value = memberEntity.health - memberEntity.tickingHealth
	healthLabel.text = LABEL_FORMAT_STRING % [memberEntity.health, memberEntity.maxHealth]
	memberEntity.connect("healthUpdated", self, "_on_memberEntity_healthUpdated")

	healthTickingBar.max_value = memberEntity.maxHealth
	healthTickingBar.value = memberEntity.health
	memberEntity.connect("tickingHealthUpdated", self, "_on_memberEntity_healthTickingUpdated")

	staminaBar.max_value = memberEntity.maxStamina
	renderStaminaBar()
	memberEntity.connect("staminaUpdated", self, "_on_memberEntity_staminaUpdated")

	magicBar.max_value = memberEntity.maxMagic
	magicBar.value = memberEntity.magic
	magicLabel.text = LABEL_FORMAT_STRING % [memberEntity.magic, memberEntity.maxMagic]
	memberEntity.connect("magicUpdated", self, "_on_memberEntity_magicUpdated")
	
	var avatarButton = $AvatarButton
	avatarButton.texture_normal = memberEntity.avatar
	avatarButton.connect("pressed", self, "_on_avatarButton_pressed")

func _on_memberEntity_healthUpdated():
	healthBar.value = memberEntity.health - memberEntity.tickingHealth
	healthLabel.text = LABEL_FORMAT_STRING % [memberEntity.health, memberEntity.maxHealth]

func _on_memberEntity_healthTickingUpdated():
	healthTickingBar.value = memberEntity.health 
	healthLabel.text = LABEL_FORMAT_STRING % [memberEntity.health, memberEntity.maxHealth]
	
func _on_memberEntity_staminaUpdated():
	renderStaminaBar()

func _on_memberEntity_magicUpdated():
	magicBar.value = memberEntity.magic
	magicLabel.text = LABEL_FORMAT_STRING % [memberEntity.magic, memberEntity.maxMagic]

func _on_avatarButton_pressed():
	for action in memberEntity.actions:
		pass
		#var actionExecution = action.get_execution_name()
		#actionExections.call(actionExecution)
