class_name BattleSystem
extends Node2D

var player_1: Fighterz
var player_2: Fighterz
@export var victory_bar: VictoryBar

var contadorVitoriasMax: int = 2
var player1_victory: int = 0
var player2_victory: int = 0
var round_over:bool = false

@export var spawn_p1: Node2D
@export var spawn_p2: Node2D
@export var hud_health_bar: HealthBar 
@export var arena_camera: Camera2D
@onready var texto_indicador: Label = $"../UI/TextoIndicador"

func _ready():
	spawnPlayer1()
	spawnPlayer2()
	
	player_1.target = player_2
	player_2.target = player_1
	
	
	hud_health_bar.setup_hud(player_1.data, player_2.data)

func _process(delta: float) -> void:
	battleCondition()

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
	
	if arena_camera:
		arena_camera.add_target(player_1)
		
	player_1.health_changed.connect(hud_health_bar.update_health)
	
func spawnPlayer2():
	var p2_data = CharacterDb.get_character(CharacterDb.p2_selected_id)
	player_2 = p2_data.character_scene.instantiate() as Fighterz
	
	add_child(player_2) 
	player_2.global_position = spawn_p2.global_position
	
	player_2.setup_fighter(p2_data, 2)
	initializePlayer(player_2)
	
	if arena_camera:
		arena_camera.add_target(player_2)
	player_2.health_changed.connect(hud_health_bar.update_health)

func battleCondition():
	if round_over:
		return
		
	if player_1.health <= 0:
		round_over = true
		player2_victory += 1 
		texto_indicador.text = "Player 2 ganhou"
		endRound()
	elif player_2.health <= 0:
		round_over = true
		player1_victory += 1
		texto_indicador.text = "Player 1 ganhou"
		endRound()

func endRound():
	victory_bar.update_victory(player1_victory, player2_victory)
	if player1_victory >= contadorVitoriasMax:
		texto_indicador.text = "Player 1 ganhou"
	elif player2_victory >= contadorVitoriasMax:
		texto_indicador.text = "Player 2 ganhou"
	else:
		await get_tree().create_timer(2.0).timeout
		resetMatch()

func resetMatch():
	round_over = false
	texto_indicador.text = " "
	if arena_camera:
		arena_camera.remove_target(player_1)
		arena_camera.remove_target(player_2)
	
	player_1.queue_free()
	player_2.queue_free()

	spawnPlayer1()
	spawnPlayer2()
	
	player_1.target = player_2
	player_2.target = player_1
	
	hud_health_bar.setup_hud(player_1.data, player_2.data)
