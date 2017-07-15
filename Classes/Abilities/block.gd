
extends Node2D

var Name="Block"
var bool_enemy=false
var bool_friend=false
var bool_self=true
var effect="effect"
var affect=[0]
var damage=0
var auto_target=true

func use(target,by):
	get_tree().get_current_scene().Friends[target].Def+=2


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


