
extends Node2D

var Name="Slam"
var bool_enemy=true
var bool_friend=false
var bool_self=false
var effect="effect"
var affect=[0]
var damage=1

var auto_target=false

func use(target,by):
	var t=target.in_entity
	t.Damage(damage)
	#if t.Def<=0:
	t.stagger=true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


