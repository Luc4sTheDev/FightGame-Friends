class_name JumpState
extends State

func enter():
	current_character.play_anim(current_character.data.jump_anim)
	current_character.handle_jump() 

func physics_update(delta):
	current_character.apply_gravity(delta)
	current_character.movement(delta)
	
	if Input.is_action_just_pressed("jump"):
		current_character.handle_jump()
	
	if Input.is_action_just_pressed("punch"):
		state_machine.change_state(state_machine.get_node("AirState"))
		
	if current_character.is_on_floor() and current_character.velocity.y >= 0:
		state_machine.change_state(state_machine.get_node("IdleState"))
