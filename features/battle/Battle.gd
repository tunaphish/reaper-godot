extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var battleEntity: Battle

#func _init(initBattle: Battle):
#	print(initBattle)
#	battleEntity = initBattle

# Called when the node enters the scene tree for the first time.
func _ready():
	if !battleEntity:
		battleEntity = preload("res://entities/battle/testBattle.tres")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
