extends Area2D

export var speed = 250
export var acceleration = 20
export var friction = 15
export var air_gravity = 5
export var air_control = 0.1
var up_air_control = 0.05
var down_air_control = 0.2
#0.05  try
var in_air = false

var water_level = 150
var screen_size 
var velocity = Vector2(0,0)
var accel = Vector2(0,0)
var current_bubble = 0

func _ready():
	screen_size = get_viewport_rect().size
	position.x = screen_size.x/2
	
func _process(delta):
	accel=Vector2(0,0)
	
	if Input.is_action_pressed("ui_right"):
		accel.x+=1
	if Input.is_action_pressed("ui_left"):
		accel.x-=1
	if Input.is_action_pressed("ui_up"):
		accel.y-=1
	if Input.is_action_pressed("ui_down"):
		accel.y+=1
	accel = accel.normalized()
	
	in_air = (position.y<=water_level) and not in_bubble()
	
	
	if(in_air):
		velocity.y+=air_gravity
		if(abs(velocity.x)<3):
			velocity.x += sign(velocity.x)
		accel.x*=air_control
		if(accel.y<0):
			accel.y*=up_air_control
		else:
			accel.y*=down_air_control
			
	if(in_bubble()):
		accel/=2
	
	update() #draw the control trail	
		
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
			velocity = velocity.normalized() * max(acceleration,min(velocity.length()-friction,speed))
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	

func _draw():
	if(accel.length()>0):
		var acceldir = velocity.normalized()+accel.normalized().rotated(PI)*5
		"""var label = Label.new()
		var font = label.get_font("")
		draw_string(font, Vector2(30,30), str(velocity), Color(1, 1, 1))
		label.free()"""
		draw_line(Vector2(0,0),acceldir*5,Color(0.5,0.5,1),2,1)
		#draw_line(Vector2(0,0),get_global_mouse_position(),Color(0,0,1),2,1)
		
func _on_Area2D_area_entered(area):
	print(area)
	if(area.name=="FloatWater"):
		in_air=false

func in_bubble():
	return current_bubble > 0

func _on_Pfish_area_entered(area):
	if("FloatWater" in area.name):
		current_bubble+=1
		if(current_bubble==1):
			velocity/=2
	print(area.name,current_bubble)
	pass # Replace with function body.


func _on_Pfish_area_exited(area):
	if("FloatWater" in area.name):
		current_bubble-=1
	print(area.name,current_bubble)
	pass # Replace with function body.
