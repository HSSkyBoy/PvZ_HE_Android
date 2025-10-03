@icon("guard.svg")
class_name Guard
extends Resource


func is_satisfied(context_transition: Transition, context_state: StateChartState) -> bool:
    push_error("Guard.is_satisfied() is not implemented. Did you forget to override it?")
    return false


func get_supported_trigger_types() -> int:
    push_error("Guard._get_supported_trigger_types() is not implemented. Did you forget to override it?")
    return StateChart.TriggerType.NONE
