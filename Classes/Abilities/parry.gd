
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

func mod(me,target,ref):
	print("doin the parry")
	#change below to strike ability
	get_tree().get_current_scene().Es[target].in_entity.Damage(damage)
	me.mods["Strike"].remove(me.mods["Strike"].find(ref))
	#return attack does not complete
	return(false)

func use(target,by):
	#get_tree().get_current_scene().Fs[
	by.in_entity.dyn_Def+=1
	by.in_entity.mods["Strike"].append(funcref(self,"mod"))
	print(by.in_entity.mods["Strike"])
	
func get_targ(user):
	return(user)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


