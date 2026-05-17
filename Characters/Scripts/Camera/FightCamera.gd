extends Camera2D

@export var move_speed: float = 5.0
@export var zoom_speed: float = 5.0
@export var min_zoom: float = 0.6
@export var max_zoom: float = 1.3
@export var margin: Vector2 = Vector2(200, 200)

var forca_tremor: float = 0.0
@export var taxa_reducao: float = 10.0

var targets: Array[Node2D] = []

var crit_zoom_active := false
var normal_zoom := Vector2.ONE

@onready var screen_size: Vector2 = get_viewport_rect().size

func add_target(t: Node2D):
	if not t in targets:
		targets.append(t)

func remove_target(t: Node2D):
	if t in targets:
		targets.erase(t)

func _process(delta: float) -> void:
	if targets.is_empty():
		return
		
	var p = Vector2.ZERO
	
	for target in targets:
		p += target.global_position
		
	p /= targets.size()
	
	global_position = global_position.lerp(p, move_speed * delta)
	
	var r = Rect2(global_position, Vector2.ZERO)
	
	for target in targets:
		r = r.expand(target.global_position)
		
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	
	var zoom_x = screen_size.x / r.size.x
	var zoom_y = screen_size.y / r.size.y
	
	var target_zoom = min(zoom_x, zoom_y)
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)
	
	if not crit_zoom_active:
		normal_zoom = Vector2.ONE * target_zoom
		zoom = zoom.lerp(normal_zoom, zoom_speed * delta)
	
	if forca_tremor > 0:
		offset = Vector2(
			randf_range(-forca_tremor, forca_tremor),
			randf_range(-forca_tremor, forca_tremor)
		)
		
		forca_tremor = lerp(forca_tremor, 0.0, taxa_reducao * delta)
		
		if forca_tremor < 0.5:
			forca_tremor = 0.0
	else:
		offset = Vector2.ZERO

func tremer(intensidade: float):
	forca_tremor = intensidade

func crit_cam(duracao: float = 0.2):
	if crit_zoom_active:
		return
		
	crit_zoom_active = true
	
	var zoom_original = zoom
	# Usando um valor maior que 1 para APROXIMAR a câmera
	var zoom_critico = Vector2(4.0, 4.0) 
	
	var tween = create_tween()
	tween.set_ignore_time_scale(true)

	tween.tween_property(self, "zoom", zoom_critico, 0.15)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_OUT)
		
	tween.tween_interval(0.5)

	tween.tween_property(self, "zoom", zoom_original, duracao)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	tween.finished.connect(func():
		crit_zoom_active = false
	)
