extends Node2D
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	draw_rect(Rect2(0,150,screen_size.x,screen_size.y-150)
		,Color(30.0/255,60.0/255,130.0/255))
		