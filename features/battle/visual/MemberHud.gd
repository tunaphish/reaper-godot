extends PanelContainer

var State = preload("res://entities/actor.gd").State
var memberEntity: Member
onready var vstack = $VStack
onready var avatarButton = $AvatarButton
onready var avatar = $VStack/Avatar
onready var castWindow = $CastWindow
const Resources = preload("res://features/battle/visual/Resources.tscn")

signal memberPressed(memberEntity)

func setup(initMemberEntity: Member):
	memberEntity = initMemberEntity
	return self

func _ready():
	avatar.texture = memberEntity.avatar
	avatarButton.connect("pressed", self, "onAvatarButtonPressed")
	var resources = Resources.instance().setup(memberEntity)
	vstack.add_child(resources)
	memberEntity.connect("healthUpdated", self, "onHealthUpdated")
	memberEntity.connect("tickingHealthUpdated", self, "onTickingHealthUpdated")
	#memberEntity.connect("actionQueued", self, "onActionQueued")


func _process(delta):
	renderCastingWindow(delta)

const INITIAL_SIZE = Vector2(128, 0) 
const FINAL_SIZE = Vector2(128, 182)
var timer 
func renderCastingWindow(delta): 
	if not memberEntity.queuedAction: 
		timer = null 
		castWindow.rect_size = INITIAL_SIZE
		return 
	if not timer and memberEntity.queuedAction:
		timer = 0
	if timer and timer < memberEntity.queuedAction.castTimeInMs:
		var newSize = Vector2(128, clamp(FINAL_SIZE.y * (timer*1000/memberEntity.queuedAction.castTimeInMs), 0, FINAL_SIZE.y))
		castWindow.rect_size = newSize
	timer += delta

func onHealthUpdated(value):
	if (value < 0):
		shakeSprite()

func onTickingHealthUpdated(value):
	if (value > 0):
		shakeSprite()

func shakeSprite(duration = 0.03, magnitude = 10, frequency = 10):
	var shakeTween = create_tween()
	var initPosition = avatar.rect_position
	for i in frequency:
		var randomVector2 = Vector2(rand_range(-magnitude, magnitude), rand_range(-magnitude, magnitude))
		shakeTween.tween_property(avatar, "rect_position", initPosition + randomVector2, duration)
	shakeTween.tween_property(avatar, "rect_position", initPosition, duration)
	
func onAvatarButtonPressed():
	emit_signal("memberPressed", memberEntity)

# func onActionQueued():
# 	print(memberEntity.queuedAction.name)
