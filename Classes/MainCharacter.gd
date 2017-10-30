
extends Node2D

var Name="JohnDoe"
var is=true
var HP=2 setget hp_change
var Def=3

#onready var index=get_tree().get_root().get_node("/root/AbilityIndex/sword")
#keys will need to be unique
#onready var Abilities={"Attack":[get_tree().get_root().get_node("/root/AbilityIndex/sword")],"Ability":[get_tree().get_root().get_node("/root/AbilityIndex/taunt")],"Defence":[get_tree().get_root().get_node("/root/AbilityIndex/parry")],"Flee":[get_tree().get_root().get_node("/root/AbilityIndex/flee")]}
onready var Abilities={"Sword":get_tree().get_root().get_node("/root/AbilityIndex/sword"),"Taunt":get_tree().get_root().get_node("/root/AbilityIndex/taunt"),"Parry":get_tree().get_root().get_node("/root/AbilityIndex/parry"),"Flee":get_tree().get_root().get_node("/root/AbilityIndex/flee")}
onready var sprite =load("res://Art Assets/Main.jpg")





###For Combat
var scn
var ready=false setget readiness
var frame
var forfeit = false
var mods={"Strike":[]}
var dyn_Def setget def_change,get_Def
var lbl_Def
var lbl_HP
var dead=false
var stagger=false

func _ClearStagger():
	stagger=false
	

#stances get called on any turn taken
#afflictions get called on each turn, even passed turns
func readiness(val):
	print("readiness Main")
	print(val)
	if not dead:
		if val and stagger:
			ready=false
			stagger=false
		else:
			if val:
				frame.ChangeState(frame.STATE_READY)
			else:
				frame.ChangeState(frame.STATE_EXHAUSTED)
			ready=val

func targeted(from, effect):
	var blocks=false
	for k in mods.keys():
		
		for m in mods[k]:
			if not m.call("mod",self,from):
				blocks=true
	return(blocks)
	
func _ready():
	dyn_Def=Def

func _connect():
	scn.get_node("PlayerActions").connect("ClearStagger",self,"_ClearStagger")


func damage(val):
	if dyn_Def>0:
		self.dyn_Def-=min(val,dyn_Def)
	else:
		HP-=1
	lbl_HP.set_text(str(HP))

func def_change(val):
	dyn_Def=val
	lbl_Def.set_text(str(dyn_Def))

func get_Def():
	return(dyn_Def)

func hp_change(val):
	if val>HP:
		HP+=1
	if val<HP:
		HP-=1
	lbl_HP.set_text(str(HP))
	check_alive()

func check_alive():
	if HP<=0:
		dead=true
		ready=false
		frame.ChangeState(frame.STATE_EXHAUSTED)