
extends Node2D

var Name="Slam"
var bool_enemy=true
var bool_friend=false
var bool_self=false
var effect="effect"
var affect=[0]
var damage=1

var auto_target=false

func use(target):
	var t=get_tree().get_current_scene().Enemies[target]
	t.Def-=1
	if t.Def<=0:
		t.stagger()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


