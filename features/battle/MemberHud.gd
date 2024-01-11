extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var memberEntity: Member

# Called when the node enters the scene tree for the first time.
func _ready():
	if (!memberEntity):
		memberEntity = load("res://entities/member/aubrey/aubrey.tres")
	var avatarButton = $"AvatarButton"
	avatarButton.texture_normal = memberEntity.avatar
	var healthBar = $"Resources/HealthBar"
	healthBar.max_value = memberEntity.maxHealth
	healthBar.value = memberEntity.health
	var staminaBar = $"Resources/StaminaBar"
	staminaBar.max_value = memberEntity.maxStamina
	staminaBar.value = memberEntity.stamina
	memberEntity.connect("staminaUpdated", self, "_on_memberEntity_staminaUpdated")

func _on_memberEntity_staminaUpdated(actor):
	$"Resources/StaminaBar".value = actor.stamina



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
