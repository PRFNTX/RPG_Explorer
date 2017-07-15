
extends Button

var global

func _ready():
	global=get_tree().get_root().get_node("/root/AbilityIndex")
	
	# Called every time the node is added to the scene.
	# Initialization here

func _on_Button_pressed():
	var Main=get_tree().get_root().get_node("/root/AbilityIndex/MainCharacter")
	
	var Jane=get_tree().get_root().get_node("/root/AbilityIndex/Jane")
	var Sal=get_tree().get_root().get_node("/root/AbilityIndex/Sal")
	var Goblin=load("res://Classes/Enemies/Goblin.scn")
	
	global.start_battle([Main,Jane,Sal],[Goblin,Goblin,Goblin,Goblin])
