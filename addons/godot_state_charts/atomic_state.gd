@tool
@icon("atomic_state.svg")

class_name AtomicState
extends StateChartState

func _handle_transition(transition: Transition, source: StateChartState):

    var target = transition.resolve_target()
    if not target is StateChartState:
        push_error("The target state \'" + str(transition.to) + "\' of the transition from \'" + source.name + "\' is not a state.")
        return


    get_parent()._handle_transition(transition, source)


func _get_configuration_warnings() -> PackedStringArray:
    var warnings = super._get_configuration_warnings()

    for child in get_children():
        if child is StateChartState:
            warnings.append("Atomic states cannot have child states. These will be ignored.")
            break
    return warnings
