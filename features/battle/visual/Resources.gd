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
	healthBar.value = actor.health - actor.tickingHealth
	healthLabel.text = LABEL_FORMAT_STRING % [actor.health, actor.maxHealth]
	actor.connect("healthUpdated", self, "_on_actor_healthUpdated")

	healthTickingBar.max_value = actor.maxHealth
	healthTickingBar.value = actor.health
	actor.connect("tickingHealthUpdated", self, "_on_actor_healthTickingUpdated")
	actor.connect("healthTicked", self, "_on_actor_healthTicked")

	staminaBar.max_value = actor.maxStamina
	staminaBar.value = actor.stamina
	renderStaminaBar()
	actor.connect("staminaUpdated", self, "_on_actor_staminaUpdated")

	magicBar.max_value = actor.maxMagic
	magicBar.value = actor.magic
	magicLabel.text = LABEL_FORMAT_STRING % [actor.magic, actor.maxMagic]
	actor.connect("magicUpdated", self, "_on_actor_magicUpdated")


func renderStaminaBar(): 
	staminaBar.value = abs(actor.stamina)
	staminaBar.tint_progress = POSITIVE_STAMINA_COLOR if actor.stamina > 0 else NEGATIVE_STAMINA_COLOR
	staminaLabel.text = LABEL_FORMAT_STRING % [actor.stamina, actor.maxStamina]	

func _on_actor_healthUpdated():
	healthBar.value = actor.health - actor.tickingHealth
	healthLabel.text = LABEL_FORMAT_STRING % [actor.health, actor.maxHealth]

func _on_actor_healthTickingUpdated():
	healthBar.value = actor.health - actor.tickingHealth
	healthLabel.text = LABEL_FORMAT_STRING % [actor.health, actor.maxHealth]
	healthTickingBar.value = actor.health 
	healthLabel.text = LABEL_FORMAT_STRING % [actor.health, actor.maxHealth]

func _on_actor_healthTicked():
	healthTickingBar.value = actor.health 
	healthLabel.text = LABEL_FORMAT_STRING % [actor.health, actor.maxHealth]

func _on_actor_staminaUpdated():
	renderStaminaBar()

func _on_actor_magicUpdated():
	magicBar.value = actor.magic
	magicLabel.text = LABEL_FORMAT_STRING % [actor.magic, actor.maxMagic]
