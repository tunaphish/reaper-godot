extends VBoxContainer

var actor: Actor

onready var healthBar = $Container/HealthTickingBar/HealthBar
onready var healthLabel = $Container/HealthTickingBar/HealthLabel
onready var healthTickingBar = $Container/HealthTickingBar
onready var staminaBar = $Container/StaminaBar
onready var staminaLabel = $Container/StaminaBar/StaminaLabel
onready var magicBar = $Container/MagicBar
onready var magicLabel = $Container/MagicBar/MagicLabel

const LABEL_FORMAT_STRING = "%s / %s"
const NEGATIVE_STAMINA_COLOR = Color.yellow 
const POSITIVE_STAMINA_COLOR = Color.green

func setup(initActor: Actor):
	actor = initActor
	return self

func _ready():	
	healthBar.max_value = actor.maxHealth
	renderHealth()
	actor.connect("healthUpdated", self, "onHealthUpdated")

	healthTickingBar.max_value = actor.maxHealth
	healthTickingBar.value = actor.health
	actor.connect("tickingHealthUpdated", self, "onHealthTickingUpdated")
	actor.connect("healthTicked", self, "onHealthTicked")

	staminaBar.max_value = actor.maxStamina
	staminaBar.value = actor.stamina
	renderStaminaBar()
	actor.connect("staminaUpdated", self, "onStaminaUpdated")

	magicBar.max_value = actor.maxMagic
	magicBar.value = actor.magic
	magicLabel.text = LABEL_FORMAT_STRING % [actor.magic, actor.maxMagic]
	actor.connect("magicUpdated", self, "onMagicUpdated")

func onHealthUpdated(_value):
	renderHealth()

func onHealthTickingUpdated(_value):
	renderHealth()

func onHealthTicked():
	healthTickingBar.value = actor.health 
	healthLabel.text = LABEL_FORMAT_STRING % [actor.health, actor.maxHealth]

func onStaminaUpdated(_value):
	renderStaminaBar()

func onMagicUpdated(_value):
	magicBar.value = actor.magic
	magicLabel.text = LABEL_FORMAT_STRING % [actor.magic, actor.maxMagic]

func renderStaminaBar(): 
	staminaBar.value = abs(actor.stamina)
	staminaBar.tint_progress = POSITIVE_STAMINA_COLOR if actor.stamina > 0 else NEGATIVE_STAMINA_COLOR
	staminaLabel.text = LABEL_FORMAT_STRING % [actor.stamina, actor.maxStamina]	

func renderHealth():
	healthBar.value = actor.health - actor.tickingHealth
	healthTickingBar.value = actor.health 
	healthLabel.text = LABEL_FORMAT_STRING % [actor.health, actor.maxHealth]
