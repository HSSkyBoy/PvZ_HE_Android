@tool
@icon("transition.svg")
class_name Transition
extends Node

const ExpressionUtil = preload("expression_util.gd")
const DebugUtil = preload("debug_util.gd")


var _dirty: bool = true


var _target: StateChartState = null



var _supported_trigger_types: int = 0





signal taken()


@export_node_path("StateChartState") var to: NodePath:
    set(value):
        to = value
        _dirty = true
        update_configuration_warnings()



@export var event: StringName = "":
    set(value):
        event = value
        _dirty = true
        update_configuration_warnings()



@export var guard: Guard:
    set(value):
        guard = value
        _dirty = true
        update_configuration_warnings()





var delay_seconds: float = 0.0:
    set(value):
        delay_in_seconds = str(value)
        update_configuration_warnings()
    get:
        if delay_in_seconds.is_valid_float():
            return float(delay_in_seconds)
        return 0.0







var delay_in_seconds: String = "0.0":
    set(value):
        delay_in_seconds = value
        update_configuration_warnings()




var has_event: bool:
    get:
        return event != null and event.length() > 0



func is_triggered_by(trigger_type: StateChart.TriggerType) -> bool:
    if _dirty:
        _refresh_caches()
    return (_supported_trigger_types & trigger_type) != 0



func take(immediately: bool = true) -> void :
    var parent_state: StateChartState = get_parent() as StateChartState
    if parent_state == null:
        push_error("Transitions must be children of states.")
        return

    parent_state._run_transition(self, immediately)



func evaluate_guard() -> bool:
    if guard == null:
        return true

    var parent_state: StateChartState = get_parent() as StateChartState
    if parent_state == null:
        push_error("Transitions must be children of states.")
        return false

    return guard.is_satisfied(self, get_parent())



func evaluate_delay() -> float:


    if delay_in_seconds.is_valid_float():
        return float(delay_in_seconds)


    var parent_state: StateChartState = get_parent() as StateChartState
    if parent_state == null:
        push_error("Transitions must be children of states.")
        return 0.0

    var result = ExpressionUtil.evaluate_expression("delay of " + DebugUtil.path_of(self), parent_state._chart, delay_in_seconds, 0.0)
    if typeof(result) != TYPE_FLOAT:
        push_error("Expression: ", delay_in_seconds, " result: ", result, " is not a float. Returning 0.0.")
        return 0.0

    return result



func resolve_target() -> StateChartState:
    if _dirty:
        _refresh_caches()
    return _target

func _get_configuration_warnings() -> PackedStringArray:
    var warnings: Array = []
    if get_child_count() > 0:
        warnings.append("Transitions should not have children")

    if to == null or to.is_empty():
        warnings.append("The target state is not set")
    elif resolve_target() == null:
        warnings.append("The target state " + str(to) + " could not be found")

    if not (get_parent() is StateChartState):
        warnings.append("Transitions must be children of states.")

    if delay_in_seconds.strip_edges().is_empty():
        warnings.append("Delay must be a valid expression. Use 0.0 if you want no delay.")

    return warnings

func _get_property_list() -> Array:
    var properties: Array = []
    properties.append({
        "name": "delay_in_seconds", 
        "type": TYPE_STRING, 
        "usage": PROPERTY_USAGE_DEFAULT, 
        "hint": PROPERTY_HINT_EXPRESSION
    })


    properties.append({
        "name": "delay_seconds", 
        "type": TYPE_FLOAT, 
        "usage": PROPERTY_USAGE_NONE
    })

    return properties


func _refresh_caches():
    _dirty = false
    var is_automatic: bool = (event == null or event.length() == 0)

    if to != null and not to.is_empty():
        var result: Node = get_node_or_null(to)
        if result is StateChartState:
            _target = result

    _supported_trigger_types = 0
    if not is_automatic:

        _supported_trigger_types |= StateChart.TriggerType.EVENT
    else:


        _supported_trigger_types |= StateChart.TriggerType.STATE_ENTER





        if guard != null:
            _supported_trigger_types |= guard.get_supported_trigger_types()
