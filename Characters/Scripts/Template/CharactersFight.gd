extends CharacterBody2D
class_name Fighterz

@export var data: FighterData

@export var hurtBoxes: Array[Area2D]
@export var hitboxes: Array[Area2D]
@export var spriteChar: AnimatedSprite2D

var health: float
var speed: float
var jump: float
var max_jump: int

var jump_count: int = 0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# energia
var energyBar: float = 0.0
var energyMax: float = 100.0

# combo
var comboCount: int = 0
var comboMaxCount: int
var dano_atual: float
var e_critico_agora: bool = false

var can_attack: bool = true
var can_power: bool = true
var can_awaken: bool = true

var combo_timer: float = 0.0
var combo_reset_time: float = 1.0

var can_kickJump: bool = true

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	state_machine.init(self)
	
	speed = data.speed
	jump = data.jump
	max_jump = data.max_jump
	health = data.max_health
	
	comboMaxCount = data.combo_max
	dano_atual = data.base_damage

func _physics_process(delta: float) -> void:
	state_machine._physics_process(delta)
	move_and_slide()
	update_combo_timer(delta)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		jump_count = 0

func movement(_delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func handle_jump():
	if Input.is_action_just_pressed("jump") and jump_count < max_jump:
		velocity.y = -jump
		jump_count += 1

func takeDamage(amount: float, isCrit: bool = false):
	var finalDamage = amount
	
	if isCrit:
		finalDamage *= 2.0
	
	health -= finalDamage
	if health <= 0:
		die()

func die():
	set_physics_process(false)

func energyGain(amount: float):
	energyBar += amount
	if energyBar >= energyMax:
		energyBar = energyMax

func criticalDamage(danoBase: float) -> float:
	var chanceAcerto = 0.2
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

func execute_attack(stage: int):
	if stage >= hitboxes.size():
		return
	
	var hitbox_atual = hitboxes[stage]
	
	match stage:
		0:
			hitBoxActivate(hitbox_atual, 0.1, 0.2)
			play_anim(data.highpunch_anim)
		1:
			hitBoxActivate(hitbox_atual, 0.1, 0.2)
			play_anim(data.mediumpunch_anim)
		2:
			hitBoxActivate(hitbox_atual, 0.1, 0.2)
			play_anim(data.lowkick_anim)

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
	var input = Input.get_axis("ui_left", "ui_right")
	
	if can_kickJump:
		can_kickJump = false
		
		var dir = sign(input)
		
		await delay(0.3)
		
		velocity.x = dir * speed * 2.5
		velocity.y = 500
		
		var lowHitbox = hitboxes[2]
		hitBoxActivate(lowHitbox, 0.0, 0.2)
		
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
	
	if Input.is_action_just_pressed("power"):
		can_power = false
		
		if Input.is_action_pressed("ui_up"):
			powerUp()
		elif Input.is_action_pressed("ui_down"):
			powerDown()
		else:
			powerNeutral()
		
		await delay(0.5)
		can_power = true

func handle_special():
	if can_awaken:
		can_awaken = false
		
		if Input.is_action_pressed("punch") and Input.is_action_pressed("jump"):
			print("Especial ativado")
		
		await delay(0.5)
		can_awaken = true

func powerUp():
	pass

func powerNeutral():
	pass

func powerDown():
	pass
