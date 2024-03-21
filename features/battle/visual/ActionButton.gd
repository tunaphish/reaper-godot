extends ToolButton

const EmotionKey = preload("res://entities/emotion/emotion.gd").EmotionKey

onready var label = $Label
onready var panicBar = $PanicBar

var labelText: String
var actor: Actor

func setup(initLabelText, initActor):
	labelText = initLabelText
	actor = initActor
	return self

func _ready():
	panicBar.max_value = randi() % (int(min(actor.emotionalState.get(EmotionKey.PANIC, 0)*1, 5))+1)
	if panicBar.max_value > 0: 
		panicBar.visible = true
	var shakeLevel = str(min(actor.emotionalState.get(EmotionKey.ANGER, 0)*10, 50))
	label.bbcode_text = "[shake rate=25 level=%s]%s[/shake]" % [shakeLevel, labelText]

func _process(delta):
	panicBar.value += delta
	if panicBar.value >= panicBar.max_value:
		panicBar.visible = false
