extends Node

@export var character_data: Array[FighterData]

var p1_selected_id:int = 0
var p2_selected_id:int = 1

func get_character(index: int):
	if index >= 0 and index < character_data.size():
		return character_data[index]
