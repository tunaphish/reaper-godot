extends ToolButton

const EmotionKey = preload("res://entities/emotion/emotion.gd").EmotionKey

onready var label = $Label

var labelText: String
var actor: Actor

var petrifiedCounter = 0

func setup(initLabelText, initActor):
	labelText = initLabelText
	actor = initActor
	return self

func _ready():
	var shakeLevel = str(min(actor.emotionalState.get(EmotionKey.ANGER, 0)*10, 50))
	label.bbcode_text = "[shake rate=25 level=%s]%s[/shake]" % [shakeLevel, labelText]