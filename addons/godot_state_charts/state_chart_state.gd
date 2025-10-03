@tool

class_name StateChartState
extends Node


signal state_entered()


signal state_exited()


signal event_received(event: StringName)


signal state_processing(delta: float)


signal state_physics_processing(delta: float)


signal state_stepped()


signal state_input(event: InputEvent)


signal state_unhandled_input(event: InputEvent)



signal transition_pending(initial_delay: float, remaining_delay: float)



var _state_active: bool = false


var active: bool:
    get: return _state_active


var _pending_transition: Transition = null


var _pending_transition_remaining_delay: float = 0

var _pending_transition_initial_delay: float = 0


var _transitions: Array[Transition] = []



var _chart: StateChart

func _ready() -> void :

    if Engine.is_editor_hint():
        return

    _chart = _find_chart(get_parent())



func _find_chart(parent: Node) -> StateChart:
    if parent is StateChart:
        return parent

    return _find_chart(parent.get_parent())



func _run_transition(transition: Transition, immediately: bool = false):
    var initial_delay: = transition.evaluate_delay()
    if not immediately and initial_delay > 0:
        _queue_transition(transition, initial_delay)
    else:
        _chart._run_transition(transition, self)




func _state_init():

    process_mode = Node.PROCESS_MODE_DISABLED
    _state_active = false
    _toggle_processing(false)


    _transitions.clear()
    for child in get_children():
        if child is Transition:
            _transitions.append(child)






func _state_enter(_transition_target: StateChartState):

    _state_active = true

    process_mode = Node.PROCESS_MODE_INHERIT


    _toggle_processing(true)


    state_entered.emit()


    _process_transitions(StateChart.TriggerType.STATE_ENTER)


func _state_exit():


    _pending_transition = null
    _pending_transition_remaining_delay = 0
    _pending_transition_initial_delay = 0
    _state_active = false

    process_mode = Node.PROCESS_MODE_DISABLED
    _toggle_processing(false)


    state_exited.emit()










func _state_save(saved_state: SavedState, child_levels: int = -1) -> void :
    if not active:
        push_error("_state_save should only be called if the state is active.")
        return


    var our_saved_state: = SavedState.new()
    our_saved_state.pending_transition_name = _pending_transition.name if _pending_transition != null else ""
    our_saved_state.pending_transition_remaining_delay = _pending_transition_remaining_delay
    our_saved_state.pending_transition_initial_delay = _pending_transition_initial_delay

    saved_state.add_substate(self, our_saved_state)

    if child_levels == 0:
        return


    var sub_child_levels: int = -1 if child_levels == -1 else child_levels - 1


    for child in get_children():
        if child is StateChartState and child.active:
            child._state_save(our_saved_state, sub_child_levels)











func _state_restore(saved_state: SavedState, child_levels: int = -1) -> void :

    var our_saved_state: = saved_state.get_substate_or_null(self)
    if our_saved_state == null:

        if active:
            _state_exit()

        return


    if not active:
        _state_enter(null)

    _pending_transition = get_node_or_null(our_saved_state.pending_transition_name) as Transition
    _pending_transition_remaining_delay = our_saved_state.pending_transition_remaining_delay
    _pending_transition_initial_delay = our_saved_state.pending_transition_initial_delay






    if child_levels == 0:
        return


    var sub_child_levels: = -1 if child_levels == -1 else child_levels - 1


    for child in get_children():
        if child is StateChartState:
            child._state_restore(our_saved_state, sub_child_levels)



func _process(delta: float) -> void :
    if Engine.is_editor_hint():
        return


    state_processing.emit(delta)

    if _pending_transition != null:
        _pending_transition_remaining_delay -= delta


        transition_pending.emit(_pending_transition.delay_seconds, max(0, _pending_transition_remaining_delay))



        if _pending_transition_remaining_delay <= 0:
            var transition_to_send: = _pending_transition
            _pending_transition = null
            _pending_transition_remaining_delay = 0

            _chart._run_transition(transition_to_send, self)



func _handle_transition(_transition: Transition, _source: StateChartState):
    push_error("State " + name + " cannot handle transitions.")


func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    state_physics_processing.emit(delta)


func _state_step():
    state_stepped.emit()

func _input(event: InputEvent):
    state_input.emit(event)


func _unhandled_input(event: InputEvent):
    state_unhandled_input.emit(event)


func _process_transitions(trigger_type: StateChart.TriggerType, event: StringName = "") -> bool:
    if not active:
        return false

    if trigger_type == StateChart.TriggerType.EVENT:
        event_received.emit(event)


    for transition in _transitions:

        if transition.is_triggered_by(trigger_type)\
\
and (event == "" or transition.event == event)\
\
and transition.evaluate_guard():



                if transition != _pending_transition:
                    _run_transition(transition)


                return true

    return false


func _queue_transition(transition: Transition, initial_delay: float):


    _pending_transition = transition
    _pending_transition_initial_delay = initial_delay
    _pending_transition_remaining_delay = initial_delay


    set_process(true)


func _get_configuration_warnings() -> PackedStringArray:
    var result: = []

    var parent: = get_parent()
    var found: = false
    while is_instance_valid(parent):
        if parent is StateChart:
            found = true
            break
        parent = parent.get_parent()

    if not found:
        result.append("State is not a child of a StateChart. This will not work.")

    return result


func _toggle_processing(active: bool):
    set_process(active and _has_connections(state_processing))
    set_physics_process(active and _has_connections(state_physics_processing))
    set_process_input(active and _has_connections(state_input))
    set_process_unhandled_input(active and _has_connections(state_unhandled_input))


func _has_connections(sgnl: Signal) -> bool:
    return sgnl.get_connections().size() > 0
