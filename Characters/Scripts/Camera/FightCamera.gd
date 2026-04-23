extends Camera2D

@export var move_speed: float = 5.0
@export var zoom_speed: float = 5.0
@export var min_zoom: float = 0.6
@export var max_zoom: float = 1.3
@export var margin: Vector2 = Vector2(200, 200)

var targets: Array[Node2D] = []

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
	
	zoom = zoom.lerp(Vector2.ONE * target_zoom, zoom_speed * delta)
