class_name JumpState
extends State

func enter():
	current_character.play_anim(current_character.data.jump_anim)
	current_character.handle_jump() 

func physics_update(delta):
	current_character.apply_gravity(delta)
	current_character.movement(delta)
	
	var p_id = str(current_character.player_id)
	var btn_jump = "p" + p_id + "_jump"
	var btn_punch = "p" + p_id + "_punch"
	
	if Input.is_action_just_pressed(btn_jump):
		current_character.handle_jump()
	
	if Input.is_action_just_pressed(btn_punch):
		state_machine.change_state(state_machine.get_node("AirState"))
		
	if current_character.is_on_floor() and current_character.velocity.y >= 0:
		state_machine.change_state(state_machine.get_node("IdleState"))
