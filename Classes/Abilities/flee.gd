
extends Node2D

var Name="Flee"
var bool_enemy=false
var bool_friend=false
var bool_self=true
var effect="effect"
var affect=[0]
var damage=0
var auto_target=true

func use(target):
	var t=get_tree().get_current_scene().Friends[target]
	t.forfeit=true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


