class_name IdleState
extends State

func enter():
	current_character.play_anim(current_character.idle_anim)
	current_character.velocity.x = 0

func physics_update(delta):
	current_character.apply_gravity(delta)
	
	if Input.is_action_pressed("punch") and  Input.is_action_pressed("jump") :
		state_machine.change_state(state_machine.get_node("SpecialState"))
		return

	if Input.get_axis("ui_left", "ui_right") != 0:
		state_machine.change_state(state_machine.get_node("MoveState"))
	
	elif Input.is_action_just_pressed("jump"):
		state_machine.change_state(state_machine.get_node("JumpState"))
	
	elif Input.is_action_just_pressed("punch"):
		state_machine.change_state(state_machine.get_node("AttackState"))
	
	elif Input.is_action_just_pressed("power"):
		state_machine.change_state(state_machine.get_node("PowerState"))

	
