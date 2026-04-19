class_name AirState
extends State

func enter():
	if Input.get_axis("ui_left", "ui_right") != 0:
		current_character.diveKick()
		current_character.play_anim(current_character.divekick_anim)
	else:
		current_character.jumpKick()
		current_character.play_anim(current_character.jumpkick_anim)

func physics_update(delta):
	current_character.apply_gravity(delta)
	
	if current_character.is_on_floor():
		state_machine.change_state(state_machine.get_node("IdleState"))
