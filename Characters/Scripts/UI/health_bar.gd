class_name HealthBar
extends Control

# assets
@onready var player1Name: Label = $Label
@onready var player1Health: ProgressBar = $ProgressBar
@onready var player2Name: Label = $Label2
@onready var player2Health: ProgressBar = $ProgressBar2

@onready var p1_icon: TextureRect = $Iconp1
@onready var p2_icon: TextureRect = $Iconp2


func setup_hud(p1_data: FighterData, p2_data: FighterData) -> void:
	player1Name.text = p1_data.char_name
	player2Name.text = p2_data.char_name
	p1_icon.texture = p1_data.icon
	p2_icon.texture = p2_data.icon
	
	player1Health.max_value = p1_data.max_health
	player2Health.max_value = p2_data.max_health
	
	player1Health.value = p1_data.max_health
	player2Health.value = p2_data.max_health


func update_health(id: int, new_health: float):
	if id == 1:
		player1Health.value = new_health
	elif id == 2:
		player2Health.value = new_health
