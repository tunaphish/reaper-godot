extends Control

const origin = Vector2(230,230)
var isHover = false

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
func _on_mouse_entered():
	isHover = true

func _on_mouse_exited():
	isHover = false
		
func _process(delta):
	_moveSpriteParallax($Background, 50, 20, delta)
	_moveSpriteParallax($Actor, 75, 40, delta)
	_moveSpriteParallax($Foreground, 100, 60, delta)
	
func _moveSpriteParallax(sprite, speed, maxLength, delta):
	var targetPosition = origin+(-(get_local_mouse_position()-origin).normalized()*maxLength) if isHover else origin
	var direction = (targetPosition-sprite.position).normalized() if isHover else (origin - sprite.position).normalized()
	var movement = direction * speed * delta
	
	if sprite.position.distance_to(targetPosition) > 5:
		sprite.position += movement
