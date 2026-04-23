class_name FighterData
extends Resource

@export var char_name: String
@export var icon: CompressedTexture2D
@export var character_scene: PackedScene

var max_health:float = 100.0

# animações
@export var idle_anim: String = "idle"
@export var move_anim: String = "walk"
@export var jump_anim: String = "jump"
@export var jumpkick_anim: String = "jumpkick"
@export var divekick_anim: String = "dive_kick"
@export var highpunch_anim: String = "highpunch"
@export var mediumpunch_anim: String = "mediumpunch"
@export var lowkick_anim: String = "lowkick"

# stats
@export var speed: float = 100.0
@export var jump: float = 400.0
@export var max_jump: int = 2

# combate
@export var combo_max: int = 3
@export var base_damage: float = 10.0
