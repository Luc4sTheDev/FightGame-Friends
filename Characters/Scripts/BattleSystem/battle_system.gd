class_name BattleSystem
extends Node2D

@export var player_scene: PackedScene

@export var player_1:Fighterz
@export var player_2:Fighterz

var contadorVitoriasMax:int = 2

var player1_victory:int = 0
var player2_victory:int = 0

@export var spawn_p1:Node2D
@export var spawn_p2:Node2D

func initializePlayer(player:Fighterz):
	player.energyBar = 0.0
	player.health = 100
	player.jump_count = 0
	
func spawnPlayer1():
	player_1 = player_scene.instantiate()
	add_child(player_1)
	player_1.global_position = spawn_p1.global_position
	initializePlayer(player_1)

func spawnPlayer2():
	player_2 = player_scene.instantiate()
	add_child(player_2)
	player_2.global_position = spawn_p2.global_position
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
		print("player 1 ganhou")
	elif player2_victory >= contadorVitoriasMax:
		print("player 2 ganhou")
	else:
		resetMatch()

func resetMatch():
	player_1.queue_free()
	player_2.queue_free()

	spawnPlayer1()
	spawnPlayer2()
