
extends Node2D

var Name="empty"
var is=false
var HP=2
var Def=1

#onready var index=get_tree().get_root().get_node("/root/AbilityIndex/sword")
#keys will need to be unique
onready var Abilities={"Attack":[get_tree().get_root().get_node("/root/AbilityIndex/sword")],"Ability":[get_tree().get_root().get_node("/root/AbilityIndex/taunt")],"Defence":[get_tree().get_root().get_node("/root/AbilityIndex/parry")],"Flee":[get_tree().get_root().get_node("/root/AbilityIndex/flee")]}
onready var sprite =load("res://Art Assets/Main.jpg")





###For Combat
var ready=false setget notready,nogo
func notready(val):
	ready=false
func nogo():
	return false
	
var frame
var forfeit = true

var dyn_Def=99
var lbl_Def
var lbl_HP
var dead=true setget ,noone
func noone():
	print("testing a dead man")
	return true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func targeted(a,b):
	return(false)


