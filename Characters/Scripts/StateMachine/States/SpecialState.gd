class_name SpecialState
extends State

func enter() -> void:
	current_character.handle_special()

func physics_update(_delta: float) -> void:
	current_character.velocity.x = 0
	
	if current_character.can_awaken:
		state_machine.change_state(state_machine.get_node("IdleState"))
