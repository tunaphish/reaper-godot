extends Sprite

var actor

func setup(initPosition: Vector2, initActor: Actor):
	position = initPosition
	actor = initActor
	return self

func _ready():
	texture = actor.sprite
	actor.connect("healthUpdated", self, "onHealthUpdated")
	actor.connect("tickingHealthUpdated", self, "onTickingHealthUpdated")

func onHealthUpdated(value):
	if (value < 0):
		shakeSprite()

func onTickingHealthUpdated(value):
	if (value > 0):
		shakeSprite()

func shakeSprite(duration = 0.03, magnitude = 10, frequency = 10):
	var shakeTween = create_tween()
	var initPosition = position
	for i in frequency:
		var randomVector2 = Vector2(rand_range(-magnitude, magnitude), rand_range(-magnitude, magnitude))
		shakeTween.tween_property(self, "position", initPosition + randomVector2, duration)
	shakeTween.tween_property(self, "position", initPosition, duration)
