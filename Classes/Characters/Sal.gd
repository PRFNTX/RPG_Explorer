
extends "res://Classes/character.gd"

export(int) var new_BaseHP=null
export(int) var new_BaseDef=null
export(String) var name

onready var Abilities=getAbilities()
#{"Sword":get_tree().get_root().get_node("/root/AbilityIndex/sword"),"Vigor":get_tree().get_root().get_node("/root/AbilityIndex/vigor"),"Parry":get_tree().get_root().get_node("/root/AbilityIndex/parry"),"Flee":get_tree().get_root().get_node("/root/AbilityIndex/flee")}
export(String,FILE) var sprite
#load("res://Art Assets/Main.jpg")

func init(name=name,new_BaseHP=new_BaseHP,new_BaseDef=new_BaseDef):
	if new_BaseHP!=null:
		BaseHP=new_BaseHP
	if new_BaseDef!=null:
		BaseHP=new_BaseHP

	Name=name

func getAbilities():
	var abilities =self.get_node("abilities").get_children()
	for ability in abilities:
		Abilities[ability.get_name()]=ability
