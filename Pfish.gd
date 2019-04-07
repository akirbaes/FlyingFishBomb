extends Area2D
signal catch_butterfly


export var speed = 250
export var acceleration = 20
export var friction = 15
export var air_gravity = 5

var water_level = 150
var screen_size 
var velocity = Vector2(0,0)

func _ready():
	screen_size = get_viewport_rect().size
	position.x = screen_size.x/2
	
func _process(delta):
	var accel = Vector2()
	
	
	if Input.is_action_pressed("ui_right"):
		accel.x+=1
	if Input.is_action_pressed("ui_left"):
		accel.x-=1
	if Input.is_action_pressed("ui_up"):
		accel.y-=1
	if Input.is_action_pressed("ui_down"):
		accel.y+=1
	accel = accel.normalized()
	
	if(position.y<=water_level):
		velocity.y+=air_gravity
		if(abs(velocity.x)<3):
			velocity.x += sign(velocity.x)
		accel*=0.05
	velocity = velocity+acceleration*accel
	velocity = velocity.normalized()*min(velocity.length(),speed)
		
	if(velocity.length()>1):
		var anglevel = Vector2(abs(velocity.x), abs(velocity.y))
		if(velocity.y<=1):
			$AnimatedSprite.frame = round(fposmod(anglevel.angle()/(2*PI)*4*5,6))
			$AnimatedSprite.flip_h = velocity.x<=0
			$AnimatedSprite.flip_v = 0
			$AnimatedSprite.set_rotation(0)
		else:
			$AnimatedSprite.frame = 5-round(fposmod(anglevel.angle()/(2*PI)*4*5,6))
			$AnimatedSprite.flip_v = velocity.x<=0
			$AnimatedSprite.flip_h = 0
			$AnimatedSprite.set_rotation(PI/2)
		#if(velocity.y>0):
		#	$AnimatedSprite.set_rotation(PI/2)
		#else:
		#	$AnimatedSprite.set_rotation(0)
			

	if(velocity.length()>1):
		position += velocity * 1/60 
		#don't trust delta right now because I'm using accelleration
		
	if(position.y>water_level):
		if(accel.length()==0 and velocity.length()>acceleration):
			velocity = velocity.normalized()*max(acceleration,min(velocity.length()-friction,speed))
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


