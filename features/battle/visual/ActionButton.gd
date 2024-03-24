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
	panicBar.max_value = randi() % (int(actor.getEmotionValue(EmotionKey.PANIC))+1)
	if panicBar.max_value > 0: 
		panicBar.visible = true
	var shakeLevel = str(actor.getEmotionValue(EmotionKey.PANIC)*10)
	label.bbcode_text = "[shake rate=25 level=%s]%s[/shake]" % [shakeLevel, labelText]

func _process(delta):
	panicBar.value += delta
	if panicBar.value >= panicBar.max_value:
		panicBar.visible = false
