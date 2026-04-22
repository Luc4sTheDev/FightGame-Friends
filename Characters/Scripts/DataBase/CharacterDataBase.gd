extends Node

@export var character_data: Array[FighterData]

func DataCharacter_Selection():
	for char in character_data:
		print(" ", char)
