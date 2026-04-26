class_name MoveState
extends State

func physics_update(delta):
	current_character.apply_gravity(delta)
	current_character.movement(delta)
	current_character.play_anim(current_character.data.move_anim)
	
	var p_id = str(current_character.player_id)
	var btn_punch = "p" + p_id + "_punch"
	var btn_jump = "p" + p_id + "_jump"
	var btn_power = "p" + p_id + "_power"
	var btn_left = "p" + p_id + "_left"
	var btn_right = "p" + p_id + "_right"
	
	if Input.is_action_pressed(btn_punch) and Input.is_action_pressed(btn_jump):
		state_machine.change_state(state_machine.get_node("SpecialState"))
		return
	
	if Input.get_axis(btn_left, btn_right) == 0:
		state_machine.change_state(state_machine.get_node("IdleState"))
	
	elif Input.is_action_just_pressed(btn_jump):
		state_machine.change_state(state_machine.get_node("JumpState"))
	
	elif Input.is_action_just_pressed(btn_punch):
		state_machine.change_state(state_machine.get_node("AttackState"))
		
	elif Input.is_action_just_pressed(btn_power):
		state_machine.change_state(state_machine.get_node("PowerState"))
		
	elif current_character.gettingHurt:
		state_machine.change_state(state_machine.get_node("HurtState"))
		
	elif current_character.isZonzin:
		state_machine.change_state(state_machine.get_node("AtordoadoState"))
