extends CharacterBody2D
class_name Fighterz
signal health_changed(id: int, new_health: float)

@export var data: FighterData
var player_id: int = 1
var target: Fighterz
@onready var pivot: Node2D = $Pivot

@export var hurtBoxes: Array[Area2D]
@export var hitboxes: Array[Area2D]
@export var spriteChar: AnimatedSprite2D

var health: float
var speed: float
var jump: float
var max_jump: int

var knockback_direction := Vector2.ZERO
var knockback_stregth := 0.0
@export var knockback_friction := 800.0

var jump_count: int = 0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var energyBar: float = 0.0
var energyMax: float = 100.0

var comboCount: int = 0
var comboMaxCount: int
var dano_atual: float
var e_critico_agora: bool = false

var can_attack: bool = true
var can_power: bool = true
var can_awaken: bool = true
var gettingHurt:bool = false
var isZonzin: bool = false

var combo_timer: float = 0.0
var combo_reset_time: float = 1.0

var can_kickJump: bool = true

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	pass

func setup_fighter(fighter_data: FighterData, id: int):
	data = fighter_data
	player_id = id 
	
	speed = data.speed
	jump = data.jump
	max_jump = data.max_jump
	health = data.max_health
	
	comboMaxCount = data.combo_max
	dano_atual = data.base_damage
	state_machine.init(self)

func _physics_process(delta: float) -> void:
	if not data:
		return
		 
	face_on()
	state_machine._physics_process(delta)
	move_and_slide()
	update_combo_timer(delta)
	clamp_to_camera()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		jump_count = 0

func movement(_delta):
	var btn_left = "p" + str(player_id) + "_left"
	var btn_right = "p" + str(player_id) + "_right"
	
	var direction = Input.get_axis(btn_left, btn_right)
	
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func handle_jump():
	var btn_jump = "p" + str(player_id) + "_jump"
	
	if Input.is_action_just_pressed(btn_jump) and jump_count < max_jump:
		velocity.y = -jump
		jump_count += 1

func takeDamage(amount: float,isCrit: bool = false, xray: Sprite2D = null):
	var finalDamage = amount
	gettingHurt = true
	print("tomou dano " , dano_atual)

	if isCrit:
		finalDamage *= 2.0
		print("Tomou Critico")
		Engine.time_scale = 0.1
		spriteChar.self_modulate = Color.BLACK 
		
		if xray:
			xray.visible = true
			xray.modulate.a = 0.0
			
			var tween_in = create_tween().set_ignore_time_scale(true)
			tween_in.tween_property(xray, "modulate:a", 1.0, 0.15) 
			
		var cam = get_viewport().get_camera_2d()
		
		if cam and cam.has_method("tremer"):
			var intensidade_calculada = finalDamage / 5.0
			cam.tremer(intensidade_calculada)
		await get_tree().create_timer(0.5, true, false, true).timeout

		Engine.time_scale = 1.0
		isZonzin = true
		var tween_out = get_tree().create_tween()
		tween_out.set_parallel(true) 

		tween_out.tween_property(spriteChar, "self_modulate", Color.WHITE, 0.3)

		if xray:
			tween_out.tween_property(xray, "modulate:a", 0.0, 0.3)
			tween_out.chain().tween_callback(func(): xray.visible = false)

	health -= finalDamage
	health_changed.emit(player_id, health)
	await delay(0.3)
	gettingHurt = false
	if health <= 0:
		die()

func die():
	set_physics_process(false)

func energyGain(amount: float):
	energyBar += amount
	if energyBar >= energyMax:
		energyBar = energyMax

func criticalDamage(danoBase: float) -> float:
	var chanceAcerto = 1.0
	var mult = 2.0
	
	if randf() <= chanceAcerto:
		return danoBase * mult
	return danoBase

func fightCombo():
	if not can_attack:
		return
	
	can_attack = false
	
	var base = data.base_damage
	dano_atual = criticalDamage(base)
	e_critico_agora = dano_atual > base
		
	execute_attack(comboCount)
	comboCount += 1
	
	energyGain(0.5)
	combo_timer = combo_reset_time
	
	await spriteChar.animation_finished
	
	can_attack = true
	
	if comboCount >= comboMaxCount:
		resetCombo()

func knockback(attacker_global_position: Vector2, hit_stregth: float):
	knockback_direction = (global_position - attacker_global_position).normalized()
	knockback_stregth = hit_stregth
	
	var cam = get_viewport().get_camera_2d()
	
	if cam and cam.has_method("tremer"):
		if hit_stregth > 0:
			var intensidade_calculada = hit_stregth / 20.0
			cam.tremer(intensidade_calculada)

func execute_attack(stage: int):
	pass

func hitBoxActivate(hitbox: Area2D, delay: float, active_time: float):
	var shapes = hitbox.get_child(0)

	await get_tree().create_timer(delay).timeout
	shapes.disabled = false
	
	await get_tree().create_timer(active_time).timeout
	shapes.disabled = true

func resetCombo():
	comboCount = 0

func delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func update_combo_timer(delta):
	if comboCount > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			resetCombo()

func jumpKick():
	if can_kickJump:
		can_kickJump = false
		
		await delay(0.1)
		
		for hitbox in hitboxes:
			hitbox.get_child(0).disabled = false
		
		await delay(0.2)
		
		for hitbox in hitboxes:
			hitbox.get_child(0).disabled = true
		
		await delay(0.3)
		can_kickJump = true

func diveKick():
	var btn_left = "p" + str(player_id) + "_left"
	var btn_right = "p" + str(player_id) + "_right"
	var input = Input.get_axis(btn_left, btn_right)
	
	if can_kickJump:
		can_kickJump = false
		
		var dir = sign(input)
		if dir == 0: dir = 1 
		
		await delay(0.3)
		
		velocity.x = dir * speed * 2.5
		velocity.y = 500
		
		var lowHitbox = hitboxes[3]
		hitBoxActivate(lowHitbox, 0.0, 0.1)
		
		can_attack = false
		
		await delay(0.2)
		
		can_attack = true
		can_kickJump = true

func play_anim(anim_name: String):
	if spriteChar.animation != anim_name:
		spriteChar.play(anim_name)

func handle_power():
	if not can_power:
		return
		
	var btn_power = "p" + str(player_id) + "_power"
	var btn_up = "p" + str(player_id) + "_up"
	var btn_down = "p" + str(player_id) + "_down"
	
	if Input.is_action_just_pressed(btn_power):
		can_power = false
		
		if Input.is_action_pressed(btn_up):
			powerUp()
		elif Input.is_action_pressed(btn_down):
			powerDown()
		else:
			powerNeutral()
		
		await delay(0.5)
		can_power = true

func handle_special():
	if can_awaken:
		can_awaken = false
		
		var btn_punch = "p" + str(player_id) + "_punch"
		var btn_jump = "p" + str(player_id) + "_jump"
		
		if Input.is_action_pressed(btn_punch) and Input.is_action_pressed(btn_jump):
			print("Especial ativado para o Player ", player_id)
		
		await delay(0.5)
		can_awaken = true

func face_on():
	if global_position.x < target.global_position.x:
		pivot.scale.x = 1
	else:
		pivot.scale.x = -1

func clamp_to_camera():
	var cam = get_viewport().get_camera_2d()
	if not cam: 
		return 
	
	var screen_width = get_viewport_rect().size.x / cam.zoom.x
	
	var cam_x = cam.get_screen_center_position().x
	
	var margin = 10.0 
	
	var left_limit = cam_x - (screen_width / 2) + margin
	var right_limit = cam_x + (screen_width / 2) - margin
	
	global_position.x = clamp(global_position.x, left_limit, right_limit)

func powerUp():
	pass

func powerNeutral():
	pass

func powerDown():
	pass
