@tool




enum StateTypes{
    AtomicState = 1, 
    CompoundState = 2, 
    ParallelState = 3, 
    AnimationPlayerState = 4, 
    AnimationTreeState = 5
}


static func make_array(\
\
chart: NodePath, \
\
path: NodePath, \
\
active: bool, \
\
transition_pending: bool, \
\
transition_path: NodePath, \
\
transition_delay: float, \
\
state: StateChartState\
) -> Array:
    return [\
chart, \
path, \
active, \
transition_pending, \
transition_path, \
transition_delay, \
type_for_state(state)]


static func type_for_state(state: StateChartState) -> StateTypes:
    if state is CompoundState:
        return StateTypes.CompoundState
    elif state is ParallelState:
        return StateTypes.ParallelState
    elif state is AnimationPlayerState:
        return StateTypes.AnimationPlayerState
    elif state is AnimationTreeState:
        return StateTypes.AnimationTreeState
    else:
        return StateTypes.AtomicState


static func get_chart(array: Array) -> NodePath:
    return array[0]

static func get_state(array: Array) -> NodePath:
    return array[1]

static func get_active(array: Array) -> bool:
    return array[2]

static func get_transition_pending(array: Array) -> bool:
    return array[3]

static func get_transition_path(array: Array) -> NodePath:
    return array[4]

static func get_transition_delay(array: Array) -> float:
    return array[5]

static func get_state_type(array: Array) -> StateTypes:
    return array[6]


static func get_state_icon(array: Array) -> Texture2D:
    var type = get_state_type(array)
    if type == StateTypes.AtomicState:
        return preload("../../atomic_state.svg")
    elif type == StateTypes.CompoundState:
        return preload("../../compound_state.svg")
    elif type == StateTypes.ParallelState:
        return preload("../../parallel_state.svg")
    elif type == StateTypes.AnimationPlayerState:
        return preload("../../animation_player_state.svg")
    elif type == StateTypes.AnimationTreeState:
        return preload("../../animation_tree_state.svg")
    else:
        return null


static func set_active(array: Array, active: bool) -> void :
    array[2] = active

    if not active:
        array[3] = false
        array[4] = null
        array[5] = 0.0


static func set_transition_pending(array: Array, transition: NodePath, pending_time: float) -> void :
    array[3] = true
    array[4] = transition
    array[5] = pending_time
