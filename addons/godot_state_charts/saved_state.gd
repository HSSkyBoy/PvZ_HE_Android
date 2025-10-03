


class_name SavedState
extends Resource



@export var child_states: Dictionary = {}


@export var pending_transition_name: NodePath


@export var pending_transition_remaining_delay: float = 0


@export var pending_transition_initial_delay: float = 0


@export var history: SavedState = null



func add_substate(state: StateChartState, saved_state: SavedState):
    child_states[state.name] = saved_state


func get_substate_or_null(state: StateChartState) -> SavedState:
    return child_states.get(state.name)
