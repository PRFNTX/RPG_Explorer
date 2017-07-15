
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var scn
var Name="Jane"
var HP=2 setget hp_change
var Def=3
onready var Abilities={"Sword":get_tree().get_root().get_node("/root/AbilityIndex/sword"),"Slam":get_tree().get_root().get_node("/root/AbilityIndex/slam"),"Block":get_tree().get_root().get_node("/root/AbilityIndex/block"),"Flee":get_tree().get_root().get_node("/root/AbilityIndex/flee")}
onready var sprite =load("res://Art Assets/Jane.png")


#For Combat
var ready=false setget readiness
var frame
var lbl_Def
var lbl_HP
var mods={"Strike":[]}

var forfeit=false
var dyn_Def setget def_change,get_Def
var dead=false
var stagger=false

func _ClearStagger():
	stagger=false

#stances get called on any turn taken
#afflictions get called on each turn, even passed turns
func readiness(val):
	
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
 
func _ready():
	dyn_Def=Def
	

func _connect():
	scn.get_node("PlayerActions").connect("ClearStagger",self,"_ClearStagger")

func targeted(from, effect):
	var blocks=false
	for k in mods.keys():
		
		for m in mods[k]:
			if not m.call("mod",self,from):
				blocks=true
	return(blocks)
	

func get_Def():
	return(dyn_Def)


func def_change(val):
	dyn_Def=val
	lbl_Def.set_text(str(dyn_Def))
	

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