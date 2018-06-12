
extends Node

# member variables here, example:
# var a=2
# var b="textvar"
var ATTACKS={}
var ABILITIES={}
var DEFEND={}
var FLEE={}
var CHARACTERS={}
var ENEMIES={}

#onready var ldBATTLESCENE=load("res://RPGBattleScene.scn")
onready var ldBATTLESCENE=load("res://Battle.scn")

onready var ldATTACKS={"Sword":load("res://Classes/Abilities/sword.scn"),"Dagger":load("res://Classes/Abilities/dagger.scn"),"Staff":load("res://Classes/Abilities/staff.scn")}
onready var ldABILITIES={"Vigor":load("res://Classes/Abilities/vigor.scn"),"Slam":load("res://Classes/Abilities/slam.scn"),"Bleed":load("res://Classes/Abilities/bleed.scn"),"Smoke Bomb":load("res://Classes/Abilities/smokebomb.scn")}
onready var ldDEFEND={"Block":load("res://Classes/Abilities/block.scn"),"Invisibility":load("res://Classes/Abilities/invisibility.scn"),"Parry":load("res://Classes/Abilities/parry.scn")}
onready var ldFLEE={"Flee":load("res://Classes/Abilities/flee.scn")}
onready var ldCHARACTERS={"MainCharacter":load("res://Classes/MainCharacter.scn"),"Jane":load("res://Classes/Jane.scn"),"Sal":load("res://Classes/Sal.scn"),"empty":load("res://Classes/empty.scn")}
onready var ldENEMIES={"Goblin":load("res://Classes/Enemies/Goblin.scn")}
#Characters
var scnIn

func _ready():
	
	for key in ldATTACKS.keys():
		load_ability(ldATTACKS[key],"Attack",key)
	for key in ldABILITIES.keys():
		load_ability(ldABILITIES[key],"Ability",key)
	for key in ldDEFEND.keys():
		load_ability(ldDEFEND[key],"Defence",key)
	for key in ldFLEE.keys():
		load_ability(ldFLEE[key],"Flee",key)
	for key in ldCHARACTERS.keys():
		load_ability(ldCHARACTERS[key],"Character",key)
	for key in ldENEMIES.keys():
		load_ability(ldENEMIES[key],"Enemy",key)
	
func load_ability(ref,type,key):
	scnIn=ref.instance()
	add_child(scnIn)
	if type=="Attack":
		ATTACKS[key]=scnIn
	elif type=="Defence":
		DEFEND[key]=scnIn
	elif type=="Abilities":
		ABILITIES[key]=scnIn
	elif type=="Flee":
		FLEE[key]=scnIn
	elif type=="Character":
		CHARACTERS[key]=scnIn
	elif type=="Enemy":
		ENEMIES[key]=scnIn
var activeBattle
var fromScene
#party as node references
func start_battle(party,enemy):
	activeBattle=ldBATTLESCENE.instance()
	fromScene=get_tree().get_current_scene()
	add_child(fromScene)
	#from_scene.set_process(false)
	get_tree().get_root().add_child(activeBattle)
	get_tree().set_current_scene(activeBattle)
	activeBattle.initialize(party,enemy)

func resolve_battle():
	#take in damage, deaths and others and modify current state.
	activeBattle.queue_free()
	get_tree().get_root().add_child(fromScene)
	get_tree().set_current_scene(fromScene)
	#fromScene.set_process(true)
	
