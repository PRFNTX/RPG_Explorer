
extends Node

var Name="Smoke Bomb"
var bool_enemy=true
var bool_friend=true
var bool_self=true
var effect="ability"
var affect=[-1,0,1]
var damage=0


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func use(target,by):
	print(target)
	print(target.Identity)
	var iden = target.Identity
	var areas=[0,0]
	if iden==1:
		areas=[2]
	elif iden==2:
		areas=[1,3]
	elif iden==3:
		areas=[2,4]
	elif iden==4:
		areas=[3]
	
	var targs=[target]
	for i in areas:
		targs.append(target.get_parent().get_entity(target.friend,i-1))
	
	if not target.in_entity.dead:
		target.in_entity.stagger=true
	
	for t in targs:
		if not t.in_entity.dead:
			t.in_entity.Def+=1
			t.in_entity.ready=false
	
	#####UPDATE
	##recieve targets as array handled before this step. use affect on single target
	#for i in affect:
	#	var i_t=i+target[0]
	#	if i+target[0]>=0 and i+target[0]<5:
	#		if target[1]:
	#			if not get_tree().get_current_scene().Enemies[i_t].dead:
	#				get_tree().get_current_scene().Enemies[i_t].Def+=1
	#				get_tree().get_current_scene().Enemies[i_t].ready=false
	#				
	#		else:
	#			if not get_tree().get_current_scene().Friends[i_t].dead:
	#				get_tree().get_current_scene().Friends[i_t].dyn_Def+=1
	#				get_tree().get_current_scene().Friends[i_t].ready=false
	#				
	#if target[1]:
	#	get_tree().get_current_scene().Enemies[target[0]].stagger=true
	#else:
	#	get_tree().get_current_scene().Friends[target[0]].stagger=true
	
	#get_tree().get_current_scene().Friends[by+1].stagger=true
	
	



