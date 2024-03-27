extends Control

const Actor = preload("res://features/battle/visual/Actor.tscn")

onready var background = $Background
onready var actors = $Actors
onready var foreground = $Foreground

var battle: Battle 
var isHover = false

func setup(initBattle: Battle):
	battle = initBattle
	return self

func _ready():
	background.texture = battle.background
	foreground.texture = battle.foreground

	for i in range(battle.enemies.size()):
		var enemy = battle.enemies[i]
		var actor = Actor.instance().setup(Vector2(i*100-100, 0), enemy)
		actors.add_child(actor)
	
	# connect("mouse_entered", self, "onMouseEntered")
	# connect("mouse_exited", self, "onMouseExited")

func onMouseEntered():
	isHover = true

func onMouseExited():
	isHover = false
		
# Below handles parallax
# func _process(delta):
# 	_moveSpriteParallax(background, 50, 20, delta)
# 	_moveSpriteParallax(actor, 75, 40, delta)
# 	_moveSpriteParallax(foreground, 100, 60, delta)

# const origin = Vector2(230,230)	
# func _moveSpriteParallax(sprite, speed, maxLength, delta):
# 	var targetPosition = origin+(-(get_local_mouse_position()-origin).normalized()*maxLength) if isHover else origin
# 	var direction = (targetPosition-sprite.position).normalized() if isHover else (origin - sprite.position).normalized()
# 	var movement = direction * speed * delta
	
# 	if sprite.position.distance_to(targetPosition) > 5:
# 		sprite.position += movement
