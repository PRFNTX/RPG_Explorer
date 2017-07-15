
extends Node2D

var Selected_Item=96


func _ready():
	set_process_input(true)
	pass




func _on_Button_released():
	pass


func _on_ItemList_item_selected( index ):
	Selected_Item=index


func _on_Button_pressed():
	if get_node("ItemList").is_selected(Selected_Item):
		get_parent().Button_Pressed(get_node("ItemList").get_item_text(Selected_Item))

