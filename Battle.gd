
extends Node2D

#Enter a battle
class StateBattleInit:
	var echo = "StateBattleInit"
	var Main
	func _init(main,from):
		Main=main
	
	func Initialize(party,enemy):
		var i=0
		var j=0
		var chars = [Main.get_node(Main.F1),Main.get_node(Main.F2),Main.get_node(Main.F3),Main.get_node(Main.F4)]
		var ens = [Main.get_node(Main.E1),Main.get_node(Main.E2),Main.get_node(Main.E3),Main.get_node(Main.E4)]
		var empty_entity=Main.get_tree().get_root().get_node("/root/AbilityIndex/empty")
	
	
		for c in range(0,party.size()):
			
			chars[i].in_entity=party[c]
			chars[i].in_texture=party[c].sprite
			
			chars[i].in_def=party[c].Def
			
			#dont sent def back to node
			chars[i].get_node("HP").set_text(str(party[c].HP))
			#Friends[i].lbl_HP=FriendSlot[i].get_node("HP")
			#send health back to node
			chars[i].in_entity.frame=chars[i]
			##Friends[i].scn=self
			##Friends[i]._connect()
			chars[i].initialize()
			i+=1
		print(party.size())
		if party.size()<4:
			#var starts=["Start1","Start2","Start3","Start4"]
			for x in range(party.size(),4):
				#print(x)
				chars[x].hide()
				chars[x].in_entity=empty_entity
		print(enemy.size())
		for e in enemy:
			ens[j].in_entity=e.instance()
			ens[j].add_child(ens[j].in_entity)
			ens[j].get_node("Char").set_texture(ens[j].in_entity.sprite)
			ens[j].get_node("Def").set_text(str(ens[j].in_entity.Def))
			ens[j].get_node("HP").set_text(str(ens[j].in_entity.HP))
			ens[j].in_entity.set_bars(ens[j].get_node("Def"),ens[j].get_node("HP"))
			#ens[j]in_entity.ready_icon=Ens[j].get_node("Ready")
			ens[j].in_entity.ready=true
			ens[j].in_entity.ID=j
			ens[j].in_entity.scn=self
			#Ens[j].in_entity._connect()
			j+=1
		exit()
		
	func exit():
		Main.emit_signal("BattleInit")
		Main.ChangeState(Main.STATE_PLAYER)
	#pass to player turn

class StatePlayerTurn:
	var echo = "StatePlayerTurn"
	var Main
	var using_Ability
	func _init(main,from):
		Main=main
		
	func Endturn(char_used):
		Main.ChangeState(Main.STATE_CHANGE,Main.STATE_PLAYER)
		
	func _targetable(ablDNU,iden,friend):#for highlighting affected
		Main.emit_signal("Affected", using_Ability,iden,friend)
		
	func _targeted(targ):
		Main.emit_signal("TargetSelected", targ)
	
	func _playerActivated(iden):
		Main.emit_signal("PlayerTurn",iden)
		using_Ability=null
	
	func OpenTargeting(booF,booE,by,boo_can_target_self,abl):
		Main.emit_signal("TargetStart",booF,booE,by,boo_can_target_self,abl)
		using_Ability=abl
		
	func _Unlock():
		Main.emit_signal("PlayerTurn",99)
		
	func exit():
		Main.emit_signal("PlayerTurn")
		print("exit() not currently valid, use EddTurn() instead")
		
		#pass to change turn, and give it enemy turn parameter

class StateChangeTurns:
	var echo = "StateChangeTurn"
	var Main
	func _init(main,from):
		Main=main
		Main.emit_signal("ChangeTurns")
		if from<0:
			print("ENTERED TURN CHANGE FROM INVALID CALL")
		elif from==Main.STATE_PLAYER:
			var ready=false
			for E in Main.Es:
				if E.in_entity.ready:
					ready=true
			if not ready:
				Refresh()
			print("from change turn")
			Continue(Main.STATE_ENEMY)
			#check if enemies are readied
		elif from==Main.STATE_ENEMY:
			var ready=false
			for F in Main.Fs:
				if F.in_entity.ready:
					ready=true
			if not ready:
				Refresh()
			Continue(Main.STATE_PLAYER)

	func Refresh():
		for F in Main.Fs:
			F.in_entity.ready=true
		for E in Main.Es:
			E.in_entity.ready=true
		#refresh all entities
	
	func Continue(to):
		Main.ChangeState(to,Main.STATE_CHANGE)
		#use entered parameter to determine where to go

class StateEnemyturn:
	var echo = "StateEnemyTurn"
	var Main
	func _init(main,from):
		Main=main
		print("made it to enemy turn state")
		var Max=[0,-99,null]
		for E in Main.Es:
			var res=E.in_entity.actionValue(Main)

			if res["val"]>Max[1]:
				Max=[E.Identity,res["val"],res]
		
		
		Main.emit_signal("EnemyTurn",Max[0],Max[2])
		#take enemy action
		
	
	func exit():
		Main.emit_signal("ChangeTurns")
		Main.ChangeState(Main.STATE_CHANGE,Main.STATE_ENEMY)
		#pass to change turn, send instruction to go to player turn.

#resolve a battle
class StateBattleResolve:
	var echo = "StateBattleResolve"
	var Main
	func _init(main,from):
		Main=main
	
	func exit():
		Main.emit_signal("BattleResolves")

signal BattleInit
signal PlayerTurn
signal ChangeTurns
signal EnemyTurn
signal BattleResolves
signal Affected

signal TargetSelected
signal TargetStart

var STATE_INIT=0
var STATE_PLAYER=1
var STATE_CHANGE=2
var STATE_ENEMY=3
var STATE_RESOLVE=4

export(NodePath) var F1
export(NodePath) var F2
export(NodePath) var F3
export(NodePath) var F4
export(NodePath) var E1
export(NodePath) var E2
export(NodePath) var E3
export(NodePath) var E4

var CurrentState
func _ready():
	get_node("EnemyFrame1").connect("EnemyEndTurn",self,"_enemyturnend")
	get_node("EnemyFrame2").connect("EnemyEndTurn",self,"_enemyturnend")
	get_node("EnemyFrame3").connect("EnemyEndTurn",self,"_enemyturnend")
	get_node("EnemyFrame4").connect("EnemyEndTurn",self,"_enemyturnend")
	
	get_node("EnemyFrame1").connect("Mouseover",self,"_mouseover")
	get_node("EnemyFrame2").connect("Mouseover",self,"_mouseover")
	get_node("EnemyFrame3").connect("Mouseover",self,"_mouseover")
	get_node("EnemyFrame4").connect("Mouseover",self,"_mouseover")
	
	get_node("CharacterFrame1").connect("PlayerTurnEnd",self,"_playerturnend")
	get_node("CharacterFrame2").connect("PlayerTurnEnd",self,"_playerturnend")
	get_node("CharacterFrame3").connect("PlayerTurnEnd",self,"_playerturnend")
	get_node("CharacterFrame4").connect("PlayerTurnEnd",self,"_playerturnend")
	
	get_node("CharacterFrame1").connect("Mouseover",self,"_mouseover")
	get_node("CharacterFrame2").connect("Mouseover",self,"_mouseover")
	get_node("CharacterFrame3").connect("Mouseover",self,"_mouseover")
	get_node("CharacterFrame4").connect("Mouseover",self,"_mouseover")
	
	get_node("CharacterFrame1").connect("Activated",self,"_playerActivated")
	get_node("CharacterFrame2").connect("Activated",self,"_playerActivated")
	get_node("CharacterFrame3").connect("Activated",self,"_playerActivated")
	get_node("CharacterFrame4").connect("Activated",self,"_playerActivated")
	
	get_node(F1).connect("Targeted",self,"_targeted")
	get_node(F2).connect("Targeted",self,"_targeted")
	get_node(F3).connect("Targeted",self,"_targeted")
	get_node(F4).connect("Targeted",self,"_targeted")
	get_node(E1).connect("Targeted",self,"_targeted")
	get_node(E2).connect("Targeted",self,"_targeted")
	get_node(E3).connect("Targeted",self,"_targeted")
	get_node(E4).connect("Targeted",self,"_targeted")
	
	ChangeState(STATE_INIT)
	
	set_process_input(true)

##defer to state
func _mouseover(abl,iden,friend):
	
	if CurrentState.has_method("_targetable"):
		CurrentState.call("_targetable",abl,iden,friend)
		

func _targeted(targ):
	if CurrentState.has_method("_targeted"):
		CurrentState.call("_targeted",targ)
	

func ChangeState(newState,STATE_FROM=-1):
	
	if newState==STATE_INIT:
		CurrentState=StateBattleInit.new(self,STATE_FROM)
	elif newState==STATE_PLAYER:
		CurrentState=StatePlayerTurn.new(self,STATE_FROM)
	elif newState==STATE_CHANGE:
		CurrentState=StateChangeTurns.new(self,STATE_FROM)
	elif newState==STATE_ENEMY:
		CurrentState=StateEnemyturn.new(self,STATE_FROM)
	elif newState==STATE_RESOLVE:
		CurrentState= StateBattleResolve.new(self,STATE_FROM)


##defer to state
func _playerActivated(iden):
	if CurrentState.has_method("_playerActivated"):
		CurrentState.call("_playerActivated",iden)
	
	
func _enemyturnend(source):
	pass

func _playerturnend(source):
	if CurrentState.has_method("Endturn"):
		CurrentState.call("Endturn",source)
	
#defer to state
func OpenTargeting(booF,booE,by,boo_can_target_self,AblNd):
	if CurrentState.has_method("OpenTargeting"):
		CurrentState.call("OpenTargeting",booF,booE,by,boo_can_target_self,AblNd)
	

##########################
func initialize(party,enemy):
	if CurrentState.has_method("Initialize"):
		CurrentState.call("Initialize",party,enemy)
	
	

onready var Fs=[get_node(F1),get_node(F2),get_node(F3),get_node(F4)]
onready var Es=[get_node(E1),get_node(E2),get_node(E3),get_node(E4)]
func get_entity(bool_friend,num):
	var ret
	if bool_friend:
		ret = Fs[num]
	else:
		ret = Es[num] 
	return(ret)
	

##############################
func _input(event):
	if (event.is_action("Undo")):
		if CurrentState.has_method("_Unlock"):
			CurrentState.call("_Unlock")

##  Frame States:
	#ready
	#selected
	#unready

## UI States:
	#invisible
	#top level
		#Attacks
		#Abilities
		#Defence
		#Flee
		
			#Targeting

## Game States:
	#Initialize
	#Player turn
	#change turns
	#Enemy turn
	#Resolution

