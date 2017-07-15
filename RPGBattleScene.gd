
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
onready var FriendSlot={1:self.get_node("CharF1"),2:self.get_node("CharF2"),3:self.get_node("CharF3"),4:self.get_node("CharF4")}
onready var EnemySlot={1:self.get_node("CharE1"),2:self.get_node("CharE2"),3:self.get_node("CharE3"),4:self.get_node("CharE4")}
var Friends={1:2,2:2,3:3,4:4}
var Enemies={1:1,2:2,3:3,4:4}
var f_Defs=[1,1,1,1] setget setDef_f
var e_Defs=[1,1,1,1] setget setDef_e
var e_HPs=[1,1,1,1] setget setHP_e
#var f_HPs=[1,1,1,1] setget setHP_f
onready var index=get_tree().get_root().get_node("/root/AbilityIndex")
onready var starts =[self.get_node("CharF1/Start1"),self.get_node("CharF2/Start2"),self.get_node("CharF3/Start3"),self.get_node("CharF4/Start4")]


func _ready():
	#(nam,[abls],[stats],[equip],vis)
#	for i in Friends.keys():
#		FriendSlot[i].call(newCharacter(1,[1,2,3],[2,2,2,2],[1],"res://Art Assets/GoblinBase.png")) #call function to set slot to have stats of character Friends[i]
#	for j in Enemies.keys():
#		EnemySlot[j].call(newCharacter(1,[1,2,3],[2,2,2,2],[1],"res://Art Assets/GoblinBase.png")) #same for Enemies[j]
	var res_empty=load("res://classes/empty.scn")
	var empty=res_empty.instance()
	for i in Friends.keys():
		Friends[i]=empty
	for j in Friends.keys():
		Enemies[j]=empty


func setHP_e(ind,val):
	EnemySlot[ind].HP-=val
	e_HPs[ind]=val

func setDef_f(ind,val):
	FriendSlot[ind].get_node("Def").set_text("Def: "+str(val))
	f_Defs[ind]=val

func setDef_e(ind,val):
	EnemySlot[ind].get_node("Def").set_text("Def: "+str(val))
	f_Defs[ind]=val

func resolveDamage(bool_enemy, tar, val,flags):
	#var dmg_HP
	#var dmg_def
	#if bool_enemy:
		#run through flags
		#get enemy defence
		#val -> def dmg, hp damage
	#	e_Defs[tar]-=dmg_def
	#	e_HPs[tar]-=dmg_HP
	#	EnemySlot[tar].get_node("HP").set_text(e_HPs[tar])
	#	EnemySlot[tar].get_node("Def").set_text(e_Defs[tar])
		#internal changes, modify labels
	#else:
		#run through flags
		#get enemy defence
		#val -> def dmg, hp damage
	#	f_Defs[tar]-=dmg_def
	#	
	#	FriendSlot[tar].get_node("Def").set_text(f_Defs[tar])
	#	Friends[tar].HP-=dmg_HP
	#	FriendSlot[tar].get_node("HP").set_text(str(Friends[tar].HP))
		#internal changes, modify labels
	pass

func initialize(party, enemy):
	var i=1
	var j=1
	
	for c in range(0,party.size()):
		Friends[i]=party[c]
		
		FriendSlot[i].set_texture(party[c].sprite)
		FriendSlot[i].get_node("Def").set_text(str(party[c].Def))
		f_Defs[i]=party[c].Def
		Friends[i].lbl_Def=FriendSlot[i].get_node("Def")
		#dont sent def back to node
		FriendSlot[i].get_node("HP").set_text(str(party[c].HP))
		Friends[i].lbl_HP=FriendSlot[i].get_node("HP")
		#send health back to node
		Friends[i].actionbutton=starts[i-1]
		Friends[i].ready=true
		Friends[i].scn=self
		Friends[i]._connect()
		i+=1
	print(party.size())
	if party.size()<4:
		#var starts=["Start1","Start2","Start3","Start4"]
		for x in range(party.size()+1,5):
			print(x)
			FriendSlot[x].hide()
		
	for e in enemy:
		Enemies[j]=e.instance()
		EnemySlot[j].add_child(Enemies[j])
		EnemySlot[j].set_texture(Enemies[j].sprite)
		EnemySlot[j].get_node("Def").set_text(str(Enemies[j].Def))
		EnemySlot[j].get_node("HP").set_text(str(Enemies[j].HP))
		Enemies[j].set_bars(EnemySlot[j].get_node("Def"),EnemySlot[j].get_node("HP"))
		Enemies[j].ready_icon=EnemySlot[j].get_node("Ready")
		Enemies[j].ready=true
		Enemies[j].ID=j
		Enemies[j].scn=self
		Enemies[j]._connect()
		j+=1
	





var char_abls
onready var item_list=get_node("PlayerActions/subActions/ItemList")



func _on_Start1_pressed():
	char_abls=int(1)
	item_list.clear()
	get_node("PlayerActions").active_character=1
	get_node("PlayerActions/Complete").hide()
	


func _on_Start2_pressed():
	char_abls=int(2)
	item_list.clear()
	get_node("PlayerActions").active_character=2
	get_node("PlayerActions/Complete").hide()


func _on_Start3_pressed():
	char_abls=int(3)
	item_list.clear()
	get_node("PlayerActions").active_character=3
	get_node("PlayerActions/Complete").hide()


func _on_Start4_pressed():
	char_abls=int(4)
	item_list.clear()
	get_node("PlayerActions").active_character=4
	get_node("PlayerActions/Complete").hide()
