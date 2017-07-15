
extends Node2D

var Name="Parry"
var bool_enemy=false
var bool_friend=false
var bool_self=true
var effect="stance"
var duration=0
var affect=[0]
var damage=2

var auto_target=true

func mod(me,target):
	
	target.Damage(2)
	me.mods["Strike"].remove(me.mods["Strike"].find(self))
	return(false)

func use(target):
	get_tree().get_current_scene().Friends[target].mods["Strike"].append(self)
	
func get_targ(user):
	return(user)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


