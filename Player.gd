extends CharacterBody2D

const ANIMATION_STATE = {
	idle = 'idle',
	run = 'run',
	skid = 'skid',
}

const DIRECTION = {
	upNeutral = 'up-neutral',
	upRight = 'up-right',
	neutralRight = 'neutral-right',
	downRight = 'down-right',
	downNeutral = 'down-neutral'
}

var animationState = ANIMATION_STATE.idle;
var direction = DIRECTION.downNeutral;

const ANIMATION_STRING_FORMAT = "%s-%s";

const ACCELERATION = 3000;
const DRAG = 3;
const DEAD_ZONE = 200

var isTouching = false; 
var directionVector = Vector2(0,0);

# TODO: update to state machine
func _input(event):
	if event is InputEventScreenTouch:
		isTouching = event.is_pressed()
		directionVector = Vector2(0,0);
	if event is InputEventScreenDrag and event.velocity.length() > DEAD_ZONE:
		# TODO: add activation animation
		directionVector = event.relative.normalized();

				
func _physics_process(delta):
	setVelocity(delta);
	setAnimation()	;
	move_and_slide();
	
func setVelocity(delta):
	if isTouching:	
		velocity += directionVector * ACCELERATION * delta;
	velocity -= velocity * DRAG * delta;
	velocity.clamp(Vector2(0,0), Vector2(100,100));

func setAnimation(): 
	var angle = velocity.angle();	

	var angle_degrees = angle * 180.0 / PI;

	if angle_degrees >= -22.5 and angle_degrees < 22.5:
		direction = DIRECTION.neutralRight
		$AnimatedSprite2D.set_flip_h(false)
	elif angle_degrees >= 22.5 and angle_degrees < 67.5:
		direction = DIRECTION.downRight
		$AnimatedSprite2D.set_flip_h(false)
	elif angle_degrees >= 67.5 and angle_degrees < 112.5:
		direction = DIRECTION.downNeutral
		
	elif angle_degrees >= 112.5 and angle_degrees < 157.5:
		direction = DIRECTION.downRight
		$AnimatedSprite2D.set_flip_h(true)
	elif angle_degrees >= 157.5 or angle_degrees < -157.5:
		direction = DIRECTION.neutralRight
		$AnimatedSprite2D.set_flip_h(true)
	elif angle_degrees >= -157.5 and angle_degrees < -112.5:
		direction = DIRECTION.upRight
		$AnimatedSprite2D.set_flip_h(true)
	
	elif angle_degrees >= -112.5 and angle_degrees < -67.5:
		direction = DIRECTION.upNeutral
	elif angle_degrees >= -67.5 and angle_degrees < -22.5:
		direction = DIRECTION.upRight
		$AnimatedSprite2D.set_flip_h(false)
	

	if (velocity.length() > 500): 
		animationState = ANIMATION_STATE.run;
	elif (velocity.length() > 25):
		animationState = ANIMATION_STATE.skid;
	else: 
		animationState = ANIMATION_STATE.idle;
	
	var animationName = ANIMATION_STRING_FORMAT % [animationState, direction]
	$AnimatedSprite2D.play(animationName)
