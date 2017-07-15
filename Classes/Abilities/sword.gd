
extends Node2D
#group, type,affects (+1,+2,-1)
var Name="Sword"
var bool_enemy=true
var bool_friend=false
var bool_self=false
var effect="damage"
var affect=[0]
var damage=1

var auto_target=false



func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func use(target,by):
	#get_tree().get_current_scene().Enemies[target[0]].Damage(damage)
	target.in_enemy.Damage(damage)

