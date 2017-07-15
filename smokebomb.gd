
extends Node

var Name="Smoke Bomb"
var bool_enemy=true
var bool_friend=true
var effect="ability"
var affect=[-1,0,1]
var damage=0


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func use(target):
	print(target)


