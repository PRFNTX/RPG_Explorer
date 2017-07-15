
extends Node2D

var Name="Bleed"
var bool_enemy=true
var bool_friend=false
var bool_self=false
var effect="effect"
var duration=3
var affect=[0]
var damage=0

var auto_target=false

func use(target,by):
	#var t=get_tree().get_current_scene().Enemies[target]
	#if t.Def<=0:
	#	t.afflictions[duration].append("bleeding")
	pass
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


