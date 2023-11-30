extends CharacterBody2D

const SPEED = 100
var lean = 0

@onready var animatedSprite = $AnimatedSprite2D

func _physics_process(delta):
	_animate()
	_control(delta)
	move_and_slide()

func _animate():
	if lean>0: animatedSprite.play("leanFoward")
	elif lean<0: animatedSprite.play("leanBack")
	else:
		if velocity.x < 0.2: animatedSprite.play("idle")
		else: animatedSprite.play("ride")
	
func _control(delta):
	if Input.is_action_pressed("accelerate"):
		velocity.x += SPEED*delta
	else:
		velocity.x= lerp(velocity.x,0.0,0.2)
	lean = Input.get_axis("leanBack", "leanFoward")
