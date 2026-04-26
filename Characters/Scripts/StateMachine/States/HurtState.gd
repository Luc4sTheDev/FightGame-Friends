class_name HurtState
extends State

func enter() -> void:
	current_character.play_anim(current_character.data.hurt)
func physics_update(_delta: float) -> void:
	if current_character.knockback_stregth > 0:
		current_character.velocity = current_character.knockback_direction * current_character.knockback_stregth
		current_character.knockback_stregth = move_toward(current_character.knockback_stregth, 0, current_character.knockback_friction * _delta)
	else:
		current_character.velocity.x = 0
	current_character.apply_gravity(_delta)

	if not current_character.gettingHurt:
		state_machine.change_state(state_machine.get_node("IdleState"))
