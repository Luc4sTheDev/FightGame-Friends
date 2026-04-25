class_name StateMachine
extends Node

@export var initial_state:State
var current_state:State

func init(character: CharacterBody2D):
	for child in get_children():
		if child is State:
			child.current_character = character
			child.state_machine = self
		if initial_state:
			change_state(initial_state)


func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
