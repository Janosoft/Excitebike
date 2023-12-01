extends CharacterBody2D

const SPEED = 100
var lean = 0
var climb = 0
var descent = 0
var currentY = 208

@onready var animatedSprite = $AnimatedSprite2D

func _physics_process(delta):
	_apply_gravity()
	_animate()	
	_control(delta)
	_controlobstacles()
	move_and_slide()

func _apply_gravity():
	if !climb and !descent:
		if position.y > currentY: position.y = currentY
		else: position.y = lerp(position.y,float(currentY),0.1)

func _animate():
	if climb: animatedSprite.play("climb")
	elif descent: animatedSprite.play("descend")
	else:
		if lean>0:
			#Solo anima hasta el final
			if not (animatedSprite.animation=="leanFoward" and animatedSprite.animation_finished): animatedSprite.play("leanFoward")
		elif lean<0:
			#Solo anima hasta el final
			if not (animatedSprite.animation=="leanBack" and animatedSprite.animation_finished): animatedSprite.play("leanBack")
		else:
			if velocity.x < 0.2: animatedSprite.play("idle")
			else: animatedSprite.play("ride")
	
func _control(delta):
	if Input.is_action_pressed("accelerate"):
		velocity.x += SPEED*delta
	else:
		velocity.x= lerp(velocity.x,0.0,0.2)
	lean = Input.get_axis("leanBack", "leanFoward")

func _controlobstacles():
	if $FrontRayCast2D.is_colliding() and !$RearRayCast2D.is_colliding():
		climb= 1
	elif !$FrontRayCast2D.is_colliding() and $RearRayCast2D.is_colliding():
		pass
		descent = 1
	else:
		pass
		climb= 0
		descent= 0
