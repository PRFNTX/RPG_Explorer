
extends Node2D

var Name="Dagger"
var bool_enemy=true
var bool_friend=false
var bool_self=false
var effect="damage"
var affect=[0]
var damage=1

var auto_target=false


func use(target,by):
	#if get_tree().get_current_scene().Enemies[target[0]].Def<1:
	#	get_tree().get_current_scene().Enemies[target[0]].HP-=2
	#elif get_tree().get_current_scene().Enemies[target[0]].Def<2:
	#	get_tree().get_current_scene().Enemies[target[0]].HP-=1
	#else:
	#	get_tree().get_current_scene().Enemies[target[0]].Def-=1
	if target.in_entity.Def<1:
		target.in_entity.HP-=2
	elif target.in_entity.Def<2:
		target.in_entity.HP-=1
	else:
		target.in_entity.Def-=1
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


