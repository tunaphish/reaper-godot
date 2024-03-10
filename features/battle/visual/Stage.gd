extends Control

onready var background = $Background
onready var actor = $Actor
onready var foreground = $Foreground

var battle: Battle 
var isHover = false

func setup(initBattle: Battle):
	battle = initBattle
	return self

func _ready():
	var enemy = battle.enemies[0] # fix for multiple enemies
	background.texture = battle.background
	foreground.texture = battle.foreground
	actor.texture = enemy.sprite
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
func _on_mouse_entered():
	isHover = true

func _on_mouse_exited():
	isHover = false
		
func _process(delta):
	_moveSpriteParallax(background, 50, 20, delta)
	_moveSpriteParallax(actor, 75, 40, delta)
	_moveSpriteParallax(foreground, 100, 60, delta)

const origin = Vector2(230,230)	
func _moveSpriteParallax(sprite, speed, maxLength, delta):
	var targetPosition = origin+(-(get_local_mouse_position()-origin).normalized()*maxLength) if isHover else origin
	var direction = (targetPosition-sprite.position).normalized() if isHover else (origin - sprite.position).normalized()
	var movement = direction * speed * delta
	
	if sprite.position.distance_to(targetPosition) > 5:
		sprite.position += movement
