@icon("state_chart.svg")
@tool


class_name StateChart
extends Node


const DebuggerRemote = preload("utilities/editor_debugger/editor_debugger_remote.gd")


const StateChartUtil = preload("utilities/state_chart_util.gd")











signal event_received(event: StringName)

@export_group("Debugging")


@export var track_in_editor: bool = false






@export var warn_on_sending_unknown_events: bool = true

@export_group("")





@export var initial_expression_properties: Dictionary = {}


var _state: StateChartState = null



var _expression_properties: Dictionary = {
}


var _queued_events: Array[StringName] = []


var _property_change_pending: bool = false



var _state_change_pending: bool = false




var _locked_down: bool = false

var _queued_transitions: Array[Dictionary] = []
var _transitions_processing_active: bool = false

var _debugger_remote: DebuggerRemote = null
var _valid_event_names: Array[StringName] = []


enum TriggerType{

    NONE = 0, 

    EVENT = 1, 

    STATE_ENTER = 2, 

    PROPERTY_CHANGE = 4, 

    STATE_CHANGE = 8, 
}

func _ready() -> void :
    if Engine.is_editor_hint():
        return


    if get_child_count() != 1:
        push_error("StateChart must have exactly one child")
        return


    var child: Node = get_child(0)
    if not child is StateChartState:
        push_error("StateMachine\'s child must be a State")
        return




    if OS.is_debug_build():
        _valid_event_names = StateChartUtil.events_of(self)


    if initial_expression_properties != null:
        for key in initial_expression_properties.keys():
            if not key is String and not key is StringName:
                push_error("Expression property names must be strings. Ignoring initial expression property with key ", key)
                continue
            _expression_properties[key] = initial_expression_properties[key]


    _state = child as StateChartState
    _state._state_init()





    _enter_initial_state.call_deferred()



    if track_in_editor and OS.has_feature("editor") and not Engine.is_editor_hint():
        _debugger_remote = DebuggerRemote.new(self)


        add_child(_debugger_remote)


func _enter_initial_state():



    _transitions_processing_active = true
    _locked_down = true


    _state._state_enter(null)


    _run_queued_transitions()


    _run_changes()







func send_event(event: StringName) -> void :
    if not is_node_ready():
        push_error("State chart is not yet ready. If you call `send_event` in _ready, please call it deferred, e.g. `state_chart.send_event.call_deferred(\"my_event\").")
        return

    if not is_instance_valid(_state):
        push_error("State chart has no root state. Ignoring call to `send_event`.")
        return
    if warn_on_sending_unknown_events and event != "" and OS.is_debug_build() and not _valid_event_names.has(event):
        push_warning("State chart does not have an event \'", event, "\' defined. Sending this event will do nothing.")

    _queued_events.append(event)
    if _locked_down:
        return

    _run_changes()





func set_expression_property(name: StringName, value) -> void :
    if not is_node_ready():
        push_error("State chart is not yet ready. If you call `set_expression_property` in `_ready`, please call it deferred, e.g. `state_chart.set_expression_property.call_deferred(\"my_property\", 5).")
        return

    if not is_instance_valid(_state):
        push_error("State chart has no root state. Ignoring call to `set_expression_property`.")
        return

    _expression_properties[name] = value
    _property_change_pending = true

    if not _locked_down:
        _run_changes()




func get_expression_property(name: StringName, default: Variant = null) -> Variant:
    return _expression_properties.get(name, default)


func _run_changes() -> void :

    _locked_down = true

    while ( not _queued_events.is_empty()) or _property_change_pending or _state_change_pending:


        if _state_change_pending:
            _state_change_pending = false
            _state._process_transitions(TriggerType.STATE_CHANGE)



        if _property_change_pending:
            _property_change_pending = false
            _state._process_transitions(TriggerType.PROPERTY_CHANGE)


        if not _queued_events.is_empty():

            var next_event = _queued_events.pop_front()
            event_received.emit(next_event)
            _state._process_transitions(TriggerType.EVENT, next_event)

    _locked_down = false





func _run_transition(transition: Transition, source: StateChartState) -> void :


    _queued_transitions.append({transition: source})







    if _transitions_processing_active:
        return

    _run_queued_transitions()



func _run_queued_transitions() -> void :
    _transitions_processing_active = true

    var execution_count: = 1


    while _queued_transitions.size() > 0:
        var next_transition_entry = _queued_transitions.pop_front()
        var next_transition = next_transition_entry.keys()[0]
        var next_transition_source = next_transition_entry[next_transition]
        _do_run_transition(next_transition, next_transition_source)
        execution_count += 1

        if execution_count > 100:
            push_error("Infinite loop detected in transitions. Aborting. The state chart is now in an invalid state and no longer usable.")
            break

    _transitions_processing_active = false



    if not _locked_down:
        _run_changes()


func _do_run_transition(transition: Transition, source: StateChartState):
    if source.active:

        transition.taken.emit()
        source._handle_transition(transition, source)
        _state_change_pending = true
    else:
        _warn_not_active(transition, source)


func _warn_not_active(transition: Transition, source: StateChartState):
    push_warning("Ignoring request for transitioning from ", source.name, " to ", transition.to, " as the source state is no longer active. Check whether your trigger multiple state changes within a single frame.")





func step() -> void :
    if not is_node_ready():
        push_error("State chart is not yet ready. If you call `step` in `_ready`, please call it deferred, e.g. `state_chart.step.call_deferred()`.")
        return

    if not is_instance_valid(_state):
        push_error("State chart has no root state. Ignoring call to `step`.")
        return
    _state._state_step()

func _get_configuration_warnings() -> PackedStringArray:
    var warnings: PackedStringArray = []
    if get_child_count() != 1:
        warnings.append("StateChart must have exactly one child")
    else:
        var child: Node = get_child(0)
        if not child is StateChartState:
            warnings.append("StateChart\'s child must be a State")
    return warnings
