extends CharacterBody2D

var ACCELERATION = 3000;
var DRAG = 3;
var DEAD_ZONE = 400
var isTouching = false; 
var directionVector = Vector2(0,0);

func _input(event):
	if event is InputEventScreenTouch:
		isTouching = event.is_pressed()
	if event is InputEventScreenDrag and event.velocity.length() > DEAD_ZONE:
		directionVector = event.relative.normalized();
		print(event.velocity.length());
		

		
		# record short swipe and long swipe

		
		
		
func _physics_process(delta):
	# while touching & direction apply accelation
	
	if isTouching:	
		velocity += directionVector * ACCELERATION * delta;

	velocity -= velocity * DRAG * delta;
	# Move the player
	#print(velocity)
	velocity.clamp(Vector2(0,0), Vector2(100,100));

	move_and_slide();

	

