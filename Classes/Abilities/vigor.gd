
extends Node2D

var Name="Vigor"
var bool_enemy=false
var bool_friend=false
var bool_self=true
var effect="effect"
var affect=[0]
var damage=0

var auto_target=true

func effect(on):
	on.dyn_Def+=1
	print("vigor boost")
	print(on.dyn_Def)
	

func use(target,by):
	by.in_entity.status[funcref(self,"effect")]=3


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


