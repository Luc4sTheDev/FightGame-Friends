class_name HealthBar
extends Control

# assets
@onready var player1Name: Label = $Label
@onready var player1Health: ProgressBar = $ProgressBar
@onready var player2Name: Label = $Label2
@onready var player2Health: ProgressBar = $ProgressBar2


func setup_hud(p1_data: FighterData, p2_data: FighterData) -> void:
	player1Name.text = p1_data.char_name
	player2Name.text = p2_data.char_name
	
	player1Health.max_value = p1_data.max_health
	player2Health.max_value = p2_data.max_health
	
	player1Health.value = p1_data.max_health
	player2Health.value = p2_data.max_health
