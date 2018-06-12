extends Node2D

export(String) var modifier
export(String,FILE) var on_effect

var child
func _ready():
	child = on_effect.instance()

func effect(target):
	target.mod[modifier]=Funcref(child,'effect')

