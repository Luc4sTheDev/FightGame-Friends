extends CPUParticles2D

func _ready():
	definir_direction()
	emitting = true
	
func definir_direction():
	if Globals.player.global_position.x > global_position.x:
		direction.x = -1
	if Globals.player.global_position.x < global_position.x:
		direction.x = 1
