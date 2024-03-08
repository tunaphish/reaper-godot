extends Control

onready var popupMenu = $PopupMenu
onready var selectSound = $Select
var options: Array #String Array

signal menuClosed()
signal id_pressed(id)

func setup(initOptions):
	options = initOptions
	return self

func _ready():
	for index in options.size():
		var option = options[index] 
		popupMenu.add_item(option, index)
	popupMenu.connect("popup_hide", self, "_on_PopupMenu_popup_hide")
	popupMenu.connect("id_pressed", self, "_on_id_pressed")
	popupMenu.popup()
	selectSound.play()

func _on_PopupMenu_popup_hide():
	emit_signal("menuClosed")
	queue_free()

func _on_id_pressed(id):
	emit_signal("id_pressed", id)
	
func set_popup_position(position: Vector2):
	popupMenu.rect_position = position
