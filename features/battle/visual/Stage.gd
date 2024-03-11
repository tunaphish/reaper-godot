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
	connect("mouse_entered", self, "onMouseEntered")
	connect("mouse_exited", self, "onMouseExited")
	enemy.connect("healthUpdated", self, "onHealthUpdated")
	enemy.connect("tickingHealthUpdated", self, "onTickingHealthUpdated")

func onHealthUpdated(value):
	if (value < 0):
		shakeSprite()

func onTickingHealthUpdated(value):
	if (value > 0):
		shakeSprite()

func shakeSprite(duration = 0.03, magnitude = 10, frequency = 10):
	var shakeTween = create_tween()
	var initPosition = actor.position
	for i in frequency:
		var randomVector2 = Vector2(rand_range(-magnitude, magnitude), rand_range(-magnitude, magnitude))
		shakeTween.tween_property(actor, "position", initPosition + randomVector2, duration)
	shakeTween.tween_property(actor, "position", initPosition, duration)

func onMouseEntered():
	isHover = true

func onMouseExited():
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
