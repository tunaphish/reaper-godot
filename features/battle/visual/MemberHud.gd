extends PanelContainer

var memberEntity: Member
var battleEntity: Battle
var actionExections = preload("res://entities/action/actionExecutions.gd").new()
var actionMenuScene = preload("res://features/battle/visual/ActionMenu.tscn")

onready var healthBar = $AvatarButton/Resources/HealthTickingBar/HealthBar
onready var healthLabel = $AvatarButton/Resources/HealthTickingBar/HealthLabel
onready 	var healthTickingBar = $AvatarButton/Resources/HealthTickingBar
onready 	var staminaBar = $AvatarButton/Resources/StaminaBar
onready var staminaLabel = $AvatarButton/Resources/StaminaBar/StaminaLabel
onready 	var magicBar = $AvatarButton/Resources/MagicBar
onready var magicLabel = $AvatarButton/Resources/MagicBar/MagicLabel
onready 	var avatarButton = $AvatarButton

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
	memberEntity.connect("healthTicked", self, "_on_memberEntity_healthTicked")

	staminaBar.max_value = memberEntity.maxStamina
	renderStaminaBar()
	memberEntity.connect("staminaUpdated", self, "_on_memberEntity_staminaUpdated")

	magicBar.max_value = memberEntity.maxMagic
	magicBar.value = memberEntity.magic
	magicLabel.text = LABEL_FORMAT_STRING % [memberEntity.magic, memberEntity.maxMagic]
	memberEntity.connect("magicUpdated", self, "_on_memberEntity_magicUpdated")
	

	avatarButton.texture_normal = memberEntity.avatar
	avatarButton.connect("pressed", self, "_on_avatarButton_pressed")

func _on_memberEntity_healthUpdated():
	healthBar.value = memberEntity.health - memberEntity.tickingHealth
	healthLabel.text = LABEL_FORMAT_STRING % [memberEntity.health, memberEntity.maxHealth]

func _on_memberEntity_healthTickingUpdated():
	healthBar.value = memberEntity.health - memberEntity.tickingHealth
	healthLabel.text = LABEL_FORMAT_STRING % [memberEntity.health, memberEntity.maxHealth]
	healthTickingBar.value = memberEntity.health 
	healthLabel.text = LABEL_FORMAT_STRING % [memberEntity.health, memberEntity.maxHealth]

func _on_memberEntity_healthTicked():
	healthTickingBar.value = memberEntity.health 
	healthLabel.text = LABEL_FORMAT_STRING % [memberEntity.health, memberEntity.maxHealth]

func _on_memberEntity_staminaUpdated():
	renderStaminaBar()

func _on_memberEntity_magicUpdated():
	magicBar.value = memberEntity.magic
	magicLabel.text = LABEL_FORMAT_STRING % [memberEntity.magic, memberEntity.maxMagic]

func _on_avatarButton_pressed():
	create_action_menu()
	#for action in memberEntity.actions:
	#	var actionExecution = action.get_execution_name()
		# spawn a menu
		#actionExections.call(actionExecution, battleEntity, memberEntity, [memberEntity]) # update to actual targets
		
const INITIAL_ACTION_MENU_POSITION = Vector2(290,580);
func create_action_menu(): 
	var actionMenu = actionMenuScene.instance()
	print(avatarButton.rect_position)
	actionMenu.actions = memberEntity.actions
	add_child(actionMenu)
	actionMenu.set_popup_position(INITIAL_ACTION_MENU_POSITION)

