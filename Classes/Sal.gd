
extends Node2D
#"Sally"
#Rogue
var scn
var Name="Sal"
var is=true
var Def=2
onready var Abilities={ "Dagger":get_tree().get_root().get_node("/root/AbilityIndex/dagger"),"Smoke Bomb":get_tree().get_root().get_node("/root/AbilityIndex/smokebomb"),"Invisibility":get_tree().get_root().get_node("/root/AbilityIndex/invisibility"),"Flee":get_tree().get_root().get_node("/root/AbilityIndex/flee")}
onready var sprite=load("res://Art Assets/Sal.png")

#for combat
var ready=false setget readiness
var frame
var forfeit = false
var mods={"Strike":[]}

var dyn_Def setget def_change,get_Def
var HP=2 setget hp_change
var lbl_Def
var lbl_HP
var dead=false
var stagger=false
var status={}

func effects():
	for eff in status.keys():
		eff.call_func(self)
		if status[eff]==1:
			status.erase(eff)
		else:
			status[eff]-=1
			

func _ClearStagger():
	stagger=false

#stances get called on any turn taken
#afflictions get called on each turn, even passed turns
func readiness(val):
	print("readiness sal")
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

func _ready():
	dyn_Def=Def

func _connect():
	scn.get_node("PlayerActions").connect("ClearStagger",self,"_ClearStagger")


func targeted(from, effect):
	var blocks=false
	for k in mods.keys():
		
		for m in mods[k]:
			if not m.call_func("mod",self,from,m):
				blocks=true
	return(blocks)

func damage(val):
	if dyn_Def>0:
		self.dyn_Def-=min(val,dyn_Def)
	else:
		HP-=1
	lbl_HP.set_text(str(HP))

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