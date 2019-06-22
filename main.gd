extends Control
export var score = 0
export var water_level = 150

func _ready():
	pass # Replace with function body.
	get_node("Butterfly").connect("butterfly_caught",self,"catch_butterfly")
	get_node("Butterfly2").connect("butterfly_caught",self,"catch_butterfly")
	
	
func catch_butterfly():
	score += 1
	#print(score)
	get_node("ScoreLabel").text=str(score)
