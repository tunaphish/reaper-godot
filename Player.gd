extends KinematicBody2D

const ACCELERATION = 3000;
const DRAG = 3;
const DEAD_ZONE = 200

var velocity = Vector2.ZERO;
var isTouching = false; 
var directionVector = Vector2(0,0);

# TODO: update to state machine
func _input(event):
	if event is InputEventScreenTouch:
		isTouching = event.is_pressed()
		directionVector = Vector2(0,0);
	if event is InputEventScreenDrag and event.speed.length() > DEAD_ZONE:
		
		directionVector = event.relative.normalized();

	
func _physics_process(delta):
	setVelocity(delta);
	move_and_slide(velocity);
	
func setVelocity(delta):
	if isTouching:	
		velocity += directionVector * ACCELERATION * delta;
	velocity -= velocity * DRAG * delta;
	velocity.clamped(100);
