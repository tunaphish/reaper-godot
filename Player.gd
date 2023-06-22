extends KinematicBody2D

var speed = 400
onready var target = position
var velocity = Vector2()

func _input(event):
	if event is InputEventScreenTouch:
		target = get_global_mouse_position()


func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 5:
		move_and_slide(velocity)
