
extends Node2D

var Name="Invisibility"
var bool_enemy=false
var bool_friend=false
var bool_self=true
var effect="effect"
var affect=[0]
var damage=0

var auto_target=true

func mod(me,target,ref):
	return false

func use(target,by):
	by.in_entity.mods["Strike"].append(funcref(self,"mod"))


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


