
extends Node2D
const friend=true
export var Shift =Vector2(0,0)
export(int) var Identity = 0
#export(NodePath) var Actions
#onready var Actions = self.get_node("ActionList")

class StateInactive:
	var debug_name="Inactive"
	var Character
	var State_From
	var ID=3
	func _init(Char,hold):
		Character=Char
		State_From=hold
		Character.get_node("Debug").set_text("Inactive")
	
	func ready():
		pass
	
	func _Unlock():
		Character.ChangeState(State_From,Character)
		

class StateReady:
	#is a base state
	var debug_name="Ready"
	var Character 
	var ID=0
	func _init(Char):
		Character=Char
		Character.get_node("ActionList").hide()
		Character.get_node("Debug").set_text("Ready")
	
	func ready():
		#Character.get_node(Character.Actions).show()
		pass
		
	func Select():
		#Character.get_node("ActionList").hide()
		Character.emit_signal("Activated",Character.Identity)
		#change state to StateAction
		Character.ChangeState(Character.STATE_ACTION)
	
	func _Lock():
		Character.CurrentState=Character.StateInactive.new(Character,ID)
		


class StateAction:
	var debug_name="Action"
	var Character
	var ID=1
	func _init(Char):
		Character=Char
		Character.get_node("ActionList").show()
		Character.get_node("Debug").set_text("Action")
	
	func ready():
		pass
	
	func _toBaseState():
		Character.ChangeState(Character.STATE_READY)
	
	func Complete():
		
		Character.in_entity.ready=false
		#Character.ChangeState(Character.STATE_EXHAUSTED)
		Character.call("Targeting",false)
		Character.emit_signal("PlayerTurnEnd",Character)
	
	func TargetRecieved(targs):
		#for targ in targs:
		Character.using_Ability.use(targs,Character)
		Complete()
	
	func _Lock():
		Character.CurrentState=Character.StateInactive.new(Character,ID)

class StateExhausted:
	#is a base state
	var debug_name="Exhausted"
	var Character
	var ID=2
	func _init(Char):
		Character=Char
		Character.get_node("ActionList").hide()
		Character.get_node("Debug").set_text("Exhausted")
	
	func ready():
		pass
	
	func Refresh():
		Character.CurrentState=Character.STATE_READY
	
	func _Lock():
		Character.CurrentState=Character.StateInactive.new(Character,ID)



class StateTargetable:
	var val=1
	var debug_name="Targetable"
	var Character
	func _init(Char):
		Character=Char
	
	
	func Targeted():
		Character.emit_signal("Targeted",Character)
	
	func Mouseover(abl):
		Character.emit_signal("Mouseover",abl,Character.Identity,true)
	
	func Clear():
		Character.emit_signal("Mouseover",null,-1,true)
	

class StateUntargetable:
	var val=2
	var debug_name="Untargetable"
	var Character
	func _init(Char):
		Character=Char

const STATE_READY=0
const STATE_ACTION =1
const STATE_EXHAUSTED =2
const STATE_INACTIVE =3

signal PlayerTurnEnd
signal Activated
signal Targeted
signal Mouseover
#states:
	#ready to select
		#in
			#turn start
			
		#out
			#selected
			#select other
	
	#take action
		#in
			#selected
		#out
			#select other
			#target selected
	
	#inactive
		#in
			#animation
			#enemy turn
		#out
			#animation end
			#turn start
	
	#exhausted
		#in
			#complete action
			#staggered
		#out
			#turn reset
	

class State_Shift:
	var Character
	const Shifted=true
	const ID=1
	func _init(char):
		Character=char
		Character.set_pos(Character.get_pos()+Character.Shift)
	
	func exit():
		Character.set_pos(Character.get_pos()-Character.Shift)

class State_noShift:
	const Shifted=false
	var Character
	const ID=2
	func _init(char):
		Character=char

class State_invisShift:
	const Shifted=true
	const ID=3
	var Character
	func _init(char):
		Character=char

var CurrentState
var ShiftState

const STATESHIFT=1
const STATENOSHIFT=2
const STATEINVIS=3

const STATETARGETABLE=1
const STATEUNTARGETABLE=2

var Entity

#####################
##Character Stats
var in_entity
var in_texture
var in_def setget _defchange

func _ready():
	
	get_parent().connect("BattleInit",self,"_tempnull")
	get_parent().connect("PlayerTurn",self,"_playerturn")
	get_parent().connect("ChangeTurns",self,"_changeturns")
	get_parent().connect("EnemyTurn",self,"_enemyturn")
	get_parent().connect("BattleResolves",self,"_tempnull")
	get_parent().connect("TargetSelected",self,"_TargetComplete")
	get_parent().connect("TargetStart",self,"_targetstart")
	get_parent().connect("Affected",self,"_affected")
	#populate actions
	
	#State init
	ChangeState(STATE_READY)
	ShiftState=State_noShift
	Targeting(false)
	set_process_input(true)

###### Signal Functions ########
func _affected(abl,iden,fren):
	get_node("Cover").hide()
	
	if fren:
		if iden==-1:
			pass
		else:
			
			for i in range(0,abl.affect.size()):
				if Identity==abl.affect[i]+iden:
					get_node("Cover").show()
	
func _TargetComplete(targ):
	Targeting(false)
	#print(CurrentState.State_From.debug_name)
	if CurrentState.has_method("_Unlock"):
		CurrentState.call("_Unlock")
	#print(CurrentState.debug_name)
	if CurrentState.has_method("TargetRecieved"):
		CurrentState.call("TargetRecieved",targ)
	Shift(STATENOSHIFT)
	

	
	#enemy turn start

func _tempnull():
	pass


func _playerturn(iden):
	if CurrentState.has_method("_Unlock"):
		CurrentState.call("_Unlock")
	if CurrentState.has_method("_toBaseState"):
		CurrentState.call("_toBaseState")
	if Identity<=iden:
		Shift(STATENOSHIFT)
	elif Identity>iden:
		Shift(STATESHIFT)
	Targeting(false)

func _targetstart(booF,booE,in_self,cat_targ_self,abl):
	if CurrentState.has_method("_Lock"):
		CurrentState.call("_Lock")
	Targeting(booF)
	
func _enemyturn(dont,use):
	if CurrentState.has_method("_Lock"):
		CurrentState.call("_Lock")

func _changeturns():
	pass
##########################
func initialize():
	#known
	#character node
		#texture
		#def and hp set already
	#populate abilities
	if in_entity.is:
		for key in in_entity.Abilities.keys():
			get_node("ActionList/ItemList").add_item(key)
		get_node("Char").set_texture(in_entity.sprite)
		in_entity.ready=true;
	else:
		set_process_input(false)








################




func Shift(state):
	if not ShiftState.ID==3:
		if (state==STATESHIFT and not ShiftState.Shifted):
			ShiftState=State_Shift.new(self)
		elif state==STATENOSHIFT:
			if ShiftState.has_method("exit"):
				ShiftState.exit()
			ShiftState=State_noShift.new(self)


func ChangeState(newState,char=self):
	if newState==STATE_READY:
		CurrentState=StateReady.new(char)
	elif newState==STATE_ACTION:
		CurrentState=StateAction.new(char)
	elif newState==STATE_INACTIVE:
		CurrentState=StateInactive.new(char,CurrentState.ID)
	elif newState==STATE_EXHAUSTED:
		CurrentState=StateExhausted.new(char)

var TargetState
func Targeting(boo):
	if boo:
		TargetState=StateTargetable.new(self)
		#CurrentState=StateInactive.new(self,CurrentState)
	else:
		TargetState=StateUntargetable.new(self)
		

func _Activate():
	##shift other nodes
	#for characters in friendlies
		#if < me
			#state = normal pos
		#otherwise
			#state = shifted pos
	#me state = normal
	##show actions
	get_node("ActionList").show()

var using_Ability

func Button_Pressed(abl):
	using_Ability=in_entity.Abilities[abl]
	#print(get_parent())
	get_parent().OpenTargeting(using_Ability.bool_friend, using_Ability.bool_enemy,self,using_Ability.bool_self,using_Ability)



func _input(event):
	if (event.is_action("Select") and mouseover):
		if self.CurrentState.has_method("Select"):
			CurrentState.call("Select")
		elif TargetState.has_method("Targeted"):
			TargetState.call("Targeted")
	if (event.is_action("Undo")):
		if CurrentState.has_method("_toBaseState"):
			CurrentState.call("_toBaseState")
			emit_signal("Activated",99)
		
			#emit_signal("Activated",99)
		#emit_signal("Targeted",false)


var mouseover=false

func _on_Control_mouse_enter():
	mouseover=true
	#signal battle instead for global
	
	if TargetState.has_method("Mouseover"):
		TargetState.call("Mouseover",using_Ability)
	


func _on_Control_mouse_exit():
	mouseover=false
	#signal battle instead for global
	if TargetState.has_method("Clear"):
		TargetState.call("Clear")
	
	
	
	#######  SETTERS #############
func _defchange(val):
	in_def=val
	get_node("Def").set_text(str(in_def))
