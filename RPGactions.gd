
extends Sprite

var Abilities={}
var Attacks={}
var Defend={}
var Flee={}
var active
onready var itemList=get_node("subActions/ItemList")
var selected
onready var en_Targs=[get_parent().get_node("CharE1/TargetE1"),get_parent().get_node("CharE2/TargetE2"),get_parent().get_node("CharE3/TargetE3"),get_parent().get_node("CharE4/TargetE4")]
onready var fr_Targs=[get_parent().get_node("CharF1/TargetF1"),get_parent().get_node("CharF2/TargetF2"),get_parent().get_node("CharF3/TargetF3"),get_parent().get_node("CharF4/TargetF4")]
onready var en_hits=[get_parent().get_node("CharE1/debug_x"),get_parent().get_node("CharE2/debug_x"),get_parent().get_node("CharE3/debug_x"),get_parent().get_node("CharE4/debug_x")]
onready var fr_hits=[get_parent().get_node("CharF1/debug_x"),get_parent().get_node("CharF2/debug_x"),get_parent().get_node("CharF3/debug_x"),get_parent().get_node("CharF4/debug_x")]
onready var turn_starts={1:get_parent().get_node("CharF1/Start1"),2:get_parent().get_node("CharF2/Start2"),3:get_parent().get_node("CharF3/Start3"),4:get_parent().get_node("CharF4/Start4")}

var active_character
var par_Friends

signal ClearStagger
#var exhausted_characters={1:false,2:false,3:false,4:false}

#scattered variables
#in_abls
#par_node
#
#selectedAbility
#bool_targeting=false
#tar_mouseover
#bool_targ
#effect
#affect
#enemies =get_parent().Enemies
#friends =get_parent().Friends

func _ready():
	add_to_group("Slots")
	par_Friends=self.get_parent().Friends
	#get_parent().get_node("CharF1/Start1").add_to_group("Turns")
	#get_parent().get_node("CharF2/Start2").add_to_group("Turns")
	#get_parent().get_node("CharF3/Start3").add_to_group("Turns")
	#get_parent().get_node("CharF4/Start4").add_to_group("Turns")


var in_abls
onready var par_node=get_parent()

func get_active_abilities():
	in_abls = int(par_node.char_abls)
	


func _on_Attack_pressed():
	get_active_abilities()
	itemList.clear()
	if par_Friends[active_character].ready:
		for k in par_Friends[in_abls].Abilities["Attack"]:
			itemList.add_item(k.Name)
		get_node("Complete").hide()
	

func _on_Ability_pressed():
	get_active_abilities()
	itemList.clear()
	if par_Friends[active_character].ready:
		for k in par_Friends[in_abls].Abilities["Ability"]:
			itemList.add_item(k.Name)
		
		get_node("Complete").hide()


func _on_Defend_pressed():
	get_active_abilities()
	itemList.clear()
	if par_Friends[active_character].ready:
		for k in par_Friends[in_abls].Abilities["Defence"]:
			itemList.add_item(k.Name)
		get_node("Complete").hide()

func _on_Flee_pressed():
	get_active_abilities()
	itemList.clear()
	if par_Friends[active_character].ready:
		for k in par_Friends[in_abls].Abilities["Flee"]:
			itemList.add_item(k.Name)
		get_node("Complete").hide()


func _on_ItemList_item_selected( index ):
	get_node("Complete").show()
	selectedAbility=str(get_node("subActions/ItemList").get_item_text(index))
	

func hide_all(targs,hits):
	if targs:
		for a in en_Targs:
			a.hide()
		for b in fr_Targs:
			b.hide()
	if hits:
		for c in en_hits:
			c.hide()
		for d in fr_hits:
			d.hide()

var selectedAbility
var bool_targeting=false


###ALMOST THERE
var tar_mouseover


func _on_Complete_pressed():
	hide_all(true,true)
	#get ability from list, go to a node, enter targeting.
	var thing = get_node("/root/AbilityIndex/"+selectedAbility.to_lower().replace(" ",""))
	var bool_targeting=true
	
	bool_targ_en=thing.bool_enemy
	bool_targ_fr=thing.bool_friend
	if bool_targ_en:
		for e in en_Targs:
			e.show()
	if bool_targ_fr:
		for f in fr_Targs:
			f.show()
	if not bool_targ_en and not bool_targ_en:
		thing.get_target(par_Friends[active_character])
		#true = enemy target
		var me=[4,false]
		get_node("/root/AbilityIndex/"+selectedAbility.to_lower().replace(" ","")).use(me,active_character)
		
		par_Friends[active_character].ready=false
		#par_Friends[active_character].stagger=true
		hide_all(true,true)
		itemList.clear()
		get_node("Complete").hide()
		turn_over(true) #check for turn reset
		enemy_turn()
	
	effect=thing.effect
	affect=thing.affect
###Working here

var bool_targ_en
var bool_targ_fr
var effect
var affect
onready var enemies =get_parent().Enemies
onready var friends =get_parent().Friends

func _on_TargetF2_mouse_enter():
	hide_all(false,true)
	
	var me=2
	active_character=me
	
	#get_tree().call_group("Slots").show()
	if bool_targ_fr==true:
		for k in affect:
			if me+k<=4 and me+k>0:
				get_parent().FriendSlot[me+k].get_node("debug_x").show()



func _on_TargetF1_mouse_enter():
	hide_all(false,true)
	var me=1
	active_character=me
	
	#get_tree().call_group("Slots").show()
	if bool_targ_fr==true:
		for k in affect:
			if me+k<=4 and me+k>0:
				get_parent().FriendSlot[me+k].get_node("debug_x").show()



func _on_TargetF3_mouse_enter():
	hide_all(false,true)
	var me=3
	active_character=me
	
	#get_tree().call_group("Slots").show()
	if bool_targ_fr==true:
		for k in affect:
			if me+k<=4 and me+k>0:
				get_parent().FriendSlot[me+k].get_node("debug_x").show()
	



func _on_TargetF4_mouse_enter():
	hide_all(false,true)
	var me=4
	active_character=me
	
	#get_tree().call_group("Slots").show()
	if bool_targ_fr==true:
		for k in affect:
			if me+k<=4 and me+k>0:
				get_parent().FriendSlot[me+k].get_node("debug_x").show()
	



func _on_TargetE1_mouse_enter():
	hide_all(false,true)
	var me=1
	
	#get_tree().call_group("Slots").show()
	if bool_targ_en==true:
		for k in affect:
			if me+k<=4 and me+k>0:
				enemies[me+k].get_parent().get_node("debug_x").show()


func _on_TargetE2_mouse_enter():
	hide_all(false,true)
	var me=2
	
	#get_tree().call_group("Slots").show()
	if bool_targ_en==true:
		for k in affect:
			if me+k<=4 and me+k>0:
				enemies[me+k].get_parent().get_node("debug_x").show()


func _on_TargetE3_mouse_enter():
	hide_all(false,true)
	var me=3
	
	#get_tree().call_group("Slots").show()
	if bool_targ_en==true:
		for k in affect:
			if me+k<=4 and me+k>0:
				enemies[me+k].get_parent().get_node("debug_x").show()


func _on_TargetE4_mouse_enter():
	hide_all(false,true)
	var me=4
	
	#get_tree().call_group("Slots").show()
	if bool_targ_en==true:
		for k in affect:
			if me+k<=4 and me+k>0:
				enemies[me+k].get_parent().get_node("debug_x").show()


func _on_TargetF1_mouse_exit():
	hide_all(false,true)


func _on_TargetF2_mouse_exit():
	hide_all(false,true)


func _on_TargetF3_mouse_exit():
	hide_all(false,true)


func _on_TargetF4_mouse_exit():
	hide_all(false,true)


func _on_TargetE1_mouse_exit():
	hide_all(false,true)


func _on_TargetE2_mouse_exit():
	hide_all(false,true)


func _on_TargetE3_mouse_exit():
	hide_all(false,true)


func _on_TargetE4_mouse_exit():
	hide_all(false,true)


func _on_Start1_pressed():
	hide_all(false,true)


######
##these do nothing but will be used for more polished versions
func _on_Area0_mouse_enter():
	tar_mouseover=0


func _on_Area1_mouse_enter():
	tar_mouseover=1


func _on_Area2_mouse_enter():
	tar_mouseover=2


func _on_Area3_mouse_enter():
	tar_mouseover=3
############

####USE ABILITY

func _on_TargetF1_pressed():
	#true = enemy target
	var me =[1,false]
	get_node("/root/AbilityIndex/"+selectedAbility.to_lower().replace(" ","")).use(me,active_character)

	par_Friends[active_character].ready=false
	#par_Friends[active_character].stagger=true
	hide_all(true,true)
	itemList.clear()
	get_node("Complete").hide()
	turn_over(true) #check for turn reset
	enemy_turn()


func _on_TargetF2_pressed():
	#true = enemy target
	var me = [2,false]
	get_node("/root/AbilityIndex/"+selectedAbility.to_lower().replace(" ","")).use(me,active_character)

	par_Friends[active_character].ready=false
	#par_Friends[active_character].stagger=true
	hide_all(true,true)
	itemList.clear()
	get_node("Complete").hide()
	turn_over(true) #check for turn reset
	enemy_turn()

func _on_TargetF3_pressed():
	#true = enemy target
	var me=[3,false]
	get_node("/root/AbilityIndex/"+selectedAbility.to_lower().replace(" ","")).use(me,active_character)

	par_Friends[active_character].ready=false
	#par_Friends[active_character].stagger=true
	hide_all(true,true)
	itemList.clear()
	get_node("Complete").hide()
	turn_over(true) #check for turn reset
	enemy_turn()


func _on_TargetF4_pressed():
	#true = enemy target
	var me=[4,false]
	get_node("/root/AbilityIndex/"+selectedAbility.to_lower().replace(" ","")).use(me,active_character)

	par_Friends[active_character].ready=false
	#par_Friends[active_character].stagger=true
	hide_all(true,true)
	itemList.clear()
	get_node("Complete").hide()
	turn_over(true) #check for turn reset
	enemy_turn()


func _on_TargetE1_pressed():
	#true = enemy target
	var me=[1,true]
	get_node("/root/AbilityIndex/"+selectedAbility.to_lower().replace(" ","")).use(me,active_character)

	par_Friends[active_character].ready=false
	#par_Friends[active_character].stagger=true
	hide_all(true,true)
	itemList.clear()
	get_node("Complete").hide()
	turn_over(true) #check for turn reset
	enemy_turn()


func _on_TargetE2_pressed():
	#true = enemy target
	var me=[2,true]
	get_node("/root/AbilityIndex/"+selectedAbility.to_lower().replace(" ","")).use(me,active_character)

	par_Friends[active_character].ready=false
	#par_Friends[active_character].stagger=true
	hide_all(true,true)
	itemList.clear()
	get_node("Complete").hide()
	turn_over(true) #check for turn reset
	enemy_turn()


func _on_TargetE3_pressed():
	#true = enemy target
	var me=[3,true]
	get_node("/root/AbilityIndex/"+selectedAbility.to_lower().replace(" ","")).use(me,active_character)
	par_Friends[active_character].ready=false
	#par_Friends[active_character].stagger=true
	hide_all(true,true)
	itemList.clear()
	turn_over(true) #check for turn reset
	enemy_turn()


func _on_TargetE4_pressed():
	#true = enemy target
	var me=[4,true]
	get_node("/root/AbilityIndex/"+selectedAbility.to_lower().replace(" ","")).use(me,active_character)
	par_Friends[active_character].ready=false
	#par_Friends[active_character].stagger=true
	hide_all(true,true)
	itemList.clear()
	turn_over(true) #check for turn reset
	enemy_turn()

####ENEMY TURN!!!! OBOYOBOYOBOY
func turn_over(side):
	var turnover1=true
	var turnover2=true
	#side true = player turn end
	for rdy in par_Friends.keys():
		if par_Friends[rdy].ready:
			turnover1=false
	for rdy in self.get_parent().Enemies.keys():
		if self.get_parent().Enemies[rdy].ready:
			turnover2=false
	if turnover1 or turnover2:
		for i in self.get_parent().Friends.keys():
			self.get_parent().Friends[i].ready=(true and not par_Friends[i].dead)
		for j in self.get_parent().Enemies.keys():
			self.get_parent().Enemies[j].ready=(true and not self.get_parent().Enemies[j].dead)
	
	emit_signal("ClearStagger")
	return([turnover1,turnover2])

func enemy_turn():
	var readies=[]
	
	for e in enemies.keys():
		if enemies[e].ready:
			readies.append(enemies[e])
	#AI
	#for now go in order
	#later:
		#assign instincts:
			#preserve self
			#win at all costs
			#kill kill kill
		#preserve self is first, if that is triggered by low health/def
		#kill is triggered if a player is low
		#win at all costs triggers, this one is smart and allows 'communication'
		#kill is triggered if no players are low, for all that have not taken turns
	var turn=randi()%readies.size()
	readies[turn].start_turn()
	readies.remove(turn)
	turn_over(false)