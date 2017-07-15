
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var sizes
func _ready():
	
	sizes=[get_node("x1"),get_node("x2"),get_node("x3"),get_node("x4")]
	

func size(num):
	for k in sizes:
		k.set_visible(false)
	sizes[num].set_visible(true)


