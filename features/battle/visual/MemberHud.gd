extends PanelContainer

var memberEntity: Member
onready var avatarButton = $AvatarButton
const Resources = preload("res://features/battle/visual/Resources.tscn")

signal memberPressed(memberEntity)

func setup(initMemberEntity: Member):
	memberEntity = initMemberEntity
	return self

func _ready():
	avatarButton.texture_normal = memberEntity.avatar
	avatarButton.connect("pressed", self, "onAvatarButtonPressed")
	var resources = Resources.instance().setup(memberEntity)
	avatarButton.add_child(resources)

func onAvatarButtonPressed():
	emit_signal("memberPressed", memberEntity)
