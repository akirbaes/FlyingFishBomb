extends Area2D

export var respawn_rate = 1.0
var screen_size 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var level = 150
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.y=level

func _process(delta):
	position.x-=1

	if(position.x<-20):
		position.x=screen_size.x*respawn_rate+20

func _on_Pfish_area_entered(area):
	print_debug(area.name)
	if(area.name == "FloatingMine"):
		get_tree().reload_current_scene()