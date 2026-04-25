class_name VictoryBar
extends Control

@onready var p1_victory_1: Sprite2D = $Vitoriap1/p1victory1
@onready var p1_victory_2: Sprite2D = $Vitoriap1/p1victory2
@onready var p2_victory_1: Sprite2D = $Vitoriap2/p2victory1
@onready var p2_victory_2: Sprite2D = $Vitoriap2/p2victory2


func update_victory(p1: int, p2: int):
	p1_victory_1.visible = p1 >= 1
	p1_victory_2.visible = p1 >= 2

	p2_victory_1.visible = p2 >= 1
	p2_victory_2.visible = p2 >= 2
