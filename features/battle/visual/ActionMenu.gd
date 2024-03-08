extends Control

onready var popupMenu = $PopupMenu
onready var selectSound = $Select
var folder : Resource

signal menuClosed()
signal id_pressed(id)

func _ready():
	for index in folder.options.size():
		var option = folder.options[index] 
		if option is Action: 
			popupMenu.add_item(option.name + " " + str(option.staminaCost) + "SP " + str(option.magicCost) + "MP", index)
		if option is Folder:
			popupMenu.add_item(option.name, index)
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
