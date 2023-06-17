extends Sprite2D


var array = [
	"do I have access to this?",
	"What the hell do you want?"
]

func _init():
	# this actually happens before ready'?
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	print("read");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO;
	velocity.x += 1;

	$"Apothecary-foreground".position += velocity.normalized() * 400 * delta;
	# get children
	pass
