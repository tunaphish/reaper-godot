extends Control

const EmotionKey = preload("res://entities/emotion/emotion.gd").EmotionKey
const ActionButton = preload("res://features/battle/visual/ActionButton.tscn")
onready var popup = $Popup
onready var container = $Popup/VStack
onready var header = $Popup/VStack/Header
onready var selectSound = $Select
onready var petrifiedSound = $Petrified
onready var petrifiedFilter = $Popup/PetrifiedFilter

var options: Array #String Array
var title: String
var actor: Actor

var petrifiedCounter = 0

signal menuClosed()
signal id_pressed(id)

func setup(initOptions, initTitle, initActor):
	options = initOptions
	title = initTitle
	actor = initActor
	return self


func _ready():
	header.text = title
	for index in options.size():
		var option = options[index] 
		var actionButton = ActionButton.instance().setup(option, actor)
		actionButton.connect("pressed", self, "onPressed", [index])	
		container.add_child(actionButton)

	popup.connect("popup_hide", self, "_on_PopupMenu_popup_hide")
	petrifiedFilter.connect("pressed", self, "onPetrifiedFilterPressed")
	
	petrifiedCounter = randi() % (int(min(actor.emotionalState.get(EmotionKey.PETRIFIED, 0)*1, 5))+1)
	petrifiedFilter.visible = petrifiedCounter > 0

	popup.popup()
	selectSound.play()


func _on_PopupMenu_popup_hide():
	emit_signal("menuClosed")
	queue_free()


func onPressed(id):
	emit_signal("id_pressed", id)


func onPetrifiedFilterPressed():
	petrifiedCounter -= 1
	if petrifiedCounter < 1:
		petrifiedFilter.queue_free()
	petrifiedSound.play()
	shakePopup()
	

func shakePopup(duration = 0.03, magnitude = 10, frequency = 10):
	var shakeTween = create_tween()
	var initPosition = popup.rect_position
	for i in frequency:
		var randomVector2 = Vector2(rand_range(-magnitude, magnitude), rand_range(-magnitude, magnitude))
		shakeTween.tween_property(popup, "rect_position", initPosition + randomVector2, duration)
	shakeTween.tween_property(popup, "rect_position", initPosition, duration)
	

func setPopupPosition(position: Vector2):
	popup.rect_position = position
