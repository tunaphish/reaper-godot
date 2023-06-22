extends KinematicBody2D

var speed = 400
onready var target = position
var velocity = Vector2()

const ACTION = {
	"idle": "idle",
}

const DIRECTION = {
	"upNeutral": "up-neutral",
	"upRight": "up-right",
	"upLeft": "up-left",
	"downNeutral": "down-neutral",
	"downRight": "down-right",
	"downLeft": "down-left",
	"neutralRight": "neutral-right",
	"neutralLeft": "neutral-left",
}

const ANIM_STR_FORMAT = "%s-%s";

var action = ACTION.idle;
var direction = DIRECTION.downNeutral;

func _input(event):
	if event is InputEventScreenTouch:
		target = get_global_mouse_position()


func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	direction = get_direction(velocity);
	# look_at(target)
	if position.distance_to(target) > 5:
		$AnimatedSprite.play(ANIM_STR_FORMAT % [action, direction])
		# set animation
		move_and_slide(velocity)

func get_direction(velocity):
	var angle = velocity.angle();
	var direction = DIRECTION.downNeutral
	var angle_degrees = angle * 180.0 / PI

	if angle_degrees >= -22.5 and angle_degrees < 22.5:
		direction = DIRECTION.neutralRight
	elif angle_degrees >= 22.5 and angle_degrees < 67.5:
		direction = DIRECTION.downRight
	elif angle_degrees >= 67.5 and angle_degrees < 112.5:
		direction = DIRECTION.downNeutral
	elif angle_degrees >= 112.5 and angle_degrees < 157.5:
		direction = DIRECTION.downLeft
	elif angle_degrees >= 157.5 or angle_degrees < -157.5:
		direction = DIRECTION.neutralLeft
	elif angle_degrees >= -157.5 and angle_degrees < -112.5:
		direction = DIRECTION.upLeft
	elif angle_degrees >= -112.5 and angle_degrees < -67.5:
		direction = DIRECTION.upNeutral
	elif angle_degrees >= -67.5 and angle_degrees < -22.5:
		direction = DIRECTION.upRight
	return direction
