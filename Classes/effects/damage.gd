extends Node2D

export(int) var value

func _ready():
	pass

func effect(target):
	target.damage(value)
