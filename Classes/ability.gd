
extends Node2D

export(String) var Name
export(bool) var bool_AffectEnemy=true
export(bool) var bool_AffectFriend=false
export(bool) var bool_self=false
export(int,"none","strike","magic","blast") var type=0
export(int,'damage','aid','modify') var effect
export(String,FILE) var affect
export(int) var damage=2

export(bool) var auto_target=false

var targeting

func _ready():
	targeting=affect.instance()


func use(target,by):
	#get_tree().get_current_scene().Enemies[target[0]].Damage(damage)
	target.in_entity.Damage(damage)
	by.in_entity.dyn_Def+=1

