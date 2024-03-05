extends Control

onready var popupMenu = $PopupMenu
export(Array, Resource) var actions

func _ready():
	for index in actions.size():
		var action = actions[index] 
		print(action.name + " " + str(action.staminaCost) + "SP " + str(action.magicCost) + "MP")
		popupMenu.add_item(action.name + " " + str(action.staminaCost) + "SP " + str(action.magicCost) + "MP", index)
	popupMenu.popup()

func _on_PopupMenu_popup_hide():
	queue_free()
	
func set_popup_position(position: Vector2):
	popupMenu.rect_position = position
