class_name BattleSystem
extends Node2D

var player_1: Fighterz
var player_2: Fighterz

var contadorVitoriasMax: int = 2
var player1_victory: int = 0
var player2_victory: int = 0

@export var spawn_p1: Node2D
@export var spawn_p2: Node2D
@export var hud_health_bar: HealthBar 


func _ready():
	spawnPlayer1()
	spawnPlayer2()
	
	player_1.target = player_2
	player_2.target = player_1
	
	hud_health_bar.setup_hud(player_1.data, player_2.data)

func initializePlayer(player: Fighterz):
	player.energyBar = 0.0
	player.health = player.data.max_health 
	player.jump_count = 0
	
func spawnPlayer1():
	var p1_data = CharacterDb.get_character(CharacterDb.p1_selected_id)
	player_1 = p1_data.character_scene.instantiate() as Fighterz
	
	add_child(player_1) 
	player_1.global_position = spawn_p1.global_position
	
	player_1.setup_fighter(p1_data, 1) 
	initializePlayer(player_1)
	
func spawnPlayer2():
	var p2_data = CharacterDb.get_character(CharacterDb.p2_selected_id)
	player_2 = p2_data.character_scene.instantiate() as Fighterz
	
	add_child(player_2) 
	player_2.global_position = spawn_p2.global_position
	
	player_2.setup_fighter(p2_data, 2) 
	player_2.pivot.scale.x = -1
	initializePlayer(player_2)

func battleCondition():
	if player_1.health <= 0:
		player2_victory += 1 
		endRound()
	elif player_2.health <= 0:
		player1_victory += 1
		endRound()

func endRound():
	if player1_victory >= contadorVitoriasMax:
		print("Player 1 ganhou a partida!")
	elif player2_victory >= contadorVitoriasMax:
		print("Player 2 ganhou a partida!")
	else:
		resetMatch()

func resetMatch():
	player_1.queue_free()
	player_2.queue_free()

	spawnPlayer1()
	spawnPlayer2()
	hud_health_bar.setup_hud(player_1.data, player_2.data)
