extends Node2D

export(bool) var auto=false
export(bool) var enemy=true
export(bool) var friendly=false
export(int,"self") var autoTarget 
var target = [0]

func _ready():
	pass