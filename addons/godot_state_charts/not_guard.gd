@tool
@icon("not_guard.svg")

class_name NotGuard
extends Guard


@export var guard: Guard

func is_satisfied(context_transition: Transition, context_state: StateChartState) -> bool:
    if guard == null:
        return true
    return not guard.is_satisfied(context_transition, context_state)

func get_supported_trigger_types() -> int:
    if guard == null:
        return StateChart.TriggerType.NONE
    return guard.get_supported_trigger_types()
