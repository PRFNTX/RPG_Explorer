extends Node2D
##presets
var preName
var preAbilities={"name":'use()'}
var preStats={1:[]}
var preEquipment={1:[]}
var preVisual


#ACTIVE
var Name
var Abilities={"name":'use()'}
var Stats={}
#HP, armor, speed, mana
var Equipment={}
var Visual

#
var set=false
var reset=false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func newCharacter(nam,abls,stats,equip,vis):
	Name=nam
	Abilities=abls
	Stats=stats
	Visual=vis
	

func SetCharacter(num):
	pass