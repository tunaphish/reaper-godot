extends Control

onready var popup = $Popup
onready var container = $Popup/VStack
onready var header = $Popup/VStack/Header
onready var selectSound = $Select

var options: Array #String Array
var title: String

signal menuClosed()
signal id_pressed(id)

func setup(initOptions, initTitle):
	options = initOptions
	title = initTitle
	return self

func _ready():
	header.text = title
	for index in options.size():
		var option = options[index] 
		var actionButton = ToolButton.new()
		actionButton.text = option
		actionButton.connect("pressed", self, "onPressed", [index])
		container.add_child(actionButton)

	popup.connect("popup_hide", self, "_on_PopupMenu_popup_hide")
	
	popup.popup()
	selectSound.play()

func _on_PopupMenu_popup_hide():
	emit_signal("menuClosed")
	queue_free()

func onPressed(id):
	emit_signal("id_pressed", id)
	
func setPopupPosition(position: Vector2):
	popup.rect_position = position
