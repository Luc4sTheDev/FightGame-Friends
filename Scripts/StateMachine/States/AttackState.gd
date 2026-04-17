class_name AttackState
extends State

func enter():
	current_character.fightCombo()

func physics_update(_delta):
	current_character.velocity.x = 0
	
	if current_character.can_attack:
		state_machine.change_state(state_machine.get_node("IdleState"))
