extends Area2D
signal caught

var screen_size
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):
	timer=timer+1
	if timer%60<30:
		position.y+=1
	else:
		position.y-=1
	
	position.x-=2
	if(position.x<-16):
		position.x=screen_size.x+16
		
	#var image = get_viewport().get_texture().get_data()
	#image.flip_y()
	#image.save_png("C:/Users/ABAES/Documents/Godot/scr/screenshot"+str(timer)+".png")

func _on_Pfish_area_entered(area):
	#print_debug(area.name)
	if(area.name == "Butterfly"):
		position.x+=screen_size.x+16
