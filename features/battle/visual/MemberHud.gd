extends PanelContainer

var State = preload("res://entities/actor.gd").State
var memberEntity: Member
onready var vstack = $VStack
onready var avatarButton = $VStack/AvatarButton
onready var avatar = $VStack/AvatarButton/Avatar
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
	if memberEntity.state == State.GUARD:
		memberEntity.setState(State.NORMAL)
	emit_signal("memberPressed", memberEntity)
