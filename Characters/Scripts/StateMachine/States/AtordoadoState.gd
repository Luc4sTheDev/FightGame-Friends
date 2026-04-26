class_name AtordoadoState
extends State

var stun_duration: float = 2.0
var stun_timer: float = 2.0

func enter() -> void:
	current_character.play_anim(current_character.data.hurt)
	stun_timer = 0.0
	current_character.velocity.x = 0

func physics_update(delta: float) -> void:
	current_character.velocity.x = 0
	current_character.apply_gravity(delta) 
	stun_timer += delta

	if stun_timer >= stun_duration:
		current_character.isZonzin = false 
		state_machine.change_state(state_machine.get_node("IdleState"))
