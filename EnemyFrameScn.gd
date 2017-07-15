
extends Node2D
const friend=false
export(int) var Identity=0

class StateReady:
	var Enemy
	func _init(en):
		Enemy=en
		Enemy.get_node("Debug").set_text("Ready")
	

class StateTakingAction:
	var Enemy
	func _init(en):
		Enemy=en
		Enemy.get_node("Debug").set_text("Action")
		
	func exit():
		emit_signal("EnemyEndTurn",self)

class StateExhausted:
	var Enemy
	func _init(en):
		Enemy=en
		Enemy.get_node("Debug").set_text("exhausted")

class StateTargetable:
	var Enemy
	func _init(en):
		Enemy=en
		Enemy.get_node("Debug").set_text("Targetable")
	
	func Targeted():
		Enemy.emit_signal("Targeted",Enemy)
	
	func Mouseover(abl):
		Enemy.emit_signal("Mouseover",abl,Enemy.Identity)
	
	func Clear():
		Enemy.emit_signal("Mouseover",null,-1)

class StateUntargetable:
	var Enemy
	func _init(en):
		Enemy=en
		Enemy.get_node("Debug").set_text("Untargetable")
	
	func Clear():
		Enemy.emit_signal("Mouseover",null,-1)


signal EnemyEndTurn
signal Targeted
signal Mouseover

var STATE_READY=0
var STATE_ACTION=1
var STATE_EXHAUSTED=2

var STATE_TARGETABLE=3
var STATE_UNTARGETABLE=4
var CurrentState
##################################################
###################################################
var in_entity

func _ready():
	get_parent().connect("BattleInit",self,"_tempnull")
	get_parent().connect("PlayerTurn",self,"_Playerturn")
	get_parent().connect("ChangeTurns",self,"_tempnull")
	get_parent().connect("EnemyTurn",self,"_tempnull")
	get_parent().connect("BattleResolves",self,"_tempnull")
	get_parent().connect("TargetSelected",self,"_TargetComplete")
	get_parent().connect("TargetStart",self,"_TargetStart")
	get_parent().connect("Affected",self,"_affected")
	
	set_process_input(true)
	ChangeState(STATE_READY)
	pass
	
####### Signal Functions#######
func _affected(abl,iden):
	get_node("Cover").hide()
	
	
	if iden==-1:
		pass
	else:
		
		for i in range(abl.affect.size()):
			if Identity==abl.affect[i]+iden:
				get_node("Cover").show()

func _TargetComplete(targ):
	Targeting(false)

func _tempnull():
	pass

var ActiveAbl
func _TargetStart(booF,booE,by,tsnull,abl):
	Targeting(abl)
	ActiveAbl=abl

func _Playerturn(iden):
	pass


################################
func ChangeState(newState):
	if newState==STATE_READY:
		CurrentState=StateReady.new(self)
	elif newState==STATE_ACTION:
		CurrentState=StateTakingAction.new(self)
	elif newState==STATE_EXHAUSTED:
		CurrentState=StateExhausted.new(self)
	
	

onready var TargetState=StateUntargetable.new(self)
func Targeting(boo):
	if boo.bool_enemy:
		TargetState=StateTargetable.new(self)
	else:
		TargetState=StateUntargetable.new(self)

var mouseover=false
func _input(event):
	if mouseover and event.is_action("Select"):
		if TargetState.has_method("Targeted"):
			TargetState.call("Targeted")

func _on_Control_mouse_enter():
	mouseover=true
	if TargetState.has_method("Mouseover"):
		TargetState.call("Mouseover",ActiveAbl)


func _on_Control_mouse_exit():
	mouseover=false
	if TargetState.has_method("Clear"):
		TargetState.call("Clear")
