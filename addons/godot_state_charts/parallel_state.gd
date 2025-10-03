@tool
@icon("parallel_state.svg")


class_name ParallelState
extends StateChartState


var _sub_states: Array[StateChartState] = []

func _state_init():
    super ._state_init()

    for child in get_children():
        if child is StateChartState:
            _sub_states.append(child)
            child._state_init()





func _handle_transition(transition: Transition, source: StateChartState):

    var target = transition.resolve_target()
    if not target is StateChartState:
        push_error("The target state \'" + str(transition.to) + "\' of the transition from \'" + source.name + "\' is not a state.")
        return












    if target == self:

        _state_exit()

        _state_enter(target)
        return

    if target in get_children():

        return

    if self.is_ancestor_of(target):

        for child in get_children():
            if child is StateChartState and child.is_ancestor_of(target):

                child._handle_transition(transition, source)
                return
        return


    get_parent()._handle_transition(transition, source)

func _state_enter(transition_target: StateChartState):
    super ._state_enter(transition_target)

    for child in _sub_states:
        child._state_enter(transition_target)

func _state_exit():

    for child in _sub_states:
        child._state_exit()

    super ._state_exit()

func _state_step():
    super ._state_step()
    for child in _sub_states:
        child._state_step()

func _process_transitions(trigger_type: StateChart.TriggerType, event: StringName = "") -> bool:
    if not active:
        return false


    var handled: = false
    for child in _sub_states:
        var child_handled_it = child._process_transitions(trigger_type, event)
        handled = handled or child_handled_it


    if handled:


        if trigger_type == StateChart.TriggerType.EVENT:
            self.event_received.emit(event)
        return true



    return super ._process_transitions(trigger_type, event)

func _get_configuration_warnings() -> PackedStringArray:
    var warnings = super ._get_configuration_warnings()

    var child_count = 0
    for child in get_children():
        if child is StateChartState:
            child_count += 1

    if child_count < 2:
        warnings.append("Parallel states should have at least two child states.")


    return warnings
