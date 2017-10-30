
extends Node2D

var Name="Block"
var bool_enemy=false
var bool_friend=true
var bool_self=true
var effect="effect"
var affect=[0]
var damage=0
var auto_target=false

func use(target,by):
	if by==target:
		by.in_entity.dyn_Def+=3
	else:
		target.in_entity.dyn_Def+=2
		by.in_entity.dyn_Def+=2


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


