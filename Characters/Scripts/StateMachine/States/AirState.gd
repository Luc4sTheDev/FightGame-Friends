class_name AirState
extends State

func enter():
	var p_id = str(current_character.player_id)
	var btn_left = "p" + p_id + "_left"
	var btn_right = "p" + p_id + "_right"
	
	if Input.get_axis(btn_left, btn_right) != 0:
		current_character.diveKick()
		current_character.play_anim(current_character.data.divekick_anim)
	else:
		current_character.jumpKick()
		current_character.play_anim(current_character.data.jumpkick_anim)

func physics_update(delta):
	current_character.apply_gravity(delta)
	
	if current_character.is_on_floor():
		state_machine.change_state(state_machine.get_node("IdleState"))
