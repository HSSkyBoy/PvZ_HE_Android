@tool


extends Node

const DebuggerMessage = preload("editor_debugger_message.gd")
const SETTINGS_UPDATED_MESSAGE = DebuggerMessage.MESSAGE_PREFIX + ":scsu"
const NAME = "StateChartEditorRemoteControl"

signal settings_updated(chart: NodePath, ignore_events: bool, ignore_transitions: bool)

static func get_instance(tree: SceneTree):




    var result = tree.root.get_meta(NAME) if tree.root.has_meta(NAME) else null
    if not is_instance_valid(result):



        result = load("res://addons/godot_state_charts/utilities/editor_debugger/editor_debugger_settings_propagator.gd").new()
        result.name = NAME
        tree.root.set_meta(NAME, result)
        tree.root.add_child.call_deferred(result)

    return result




static func send_settings_update(session, chart: NodePath, ignore_events: bool, ignore_transitions: bool) -> void :
    session.send_message(SETTINGS_UPDATED_MESSAGE, [chart, ignore_events, ignore_transitions])


func _enter_tree():


    EngineDebugger.register_message_capture(DebuggerMessage.MESSAGE_PREFIX, _on_settings_updated)


func _exit_tree():

    EngineDebugger.unregister_message_capture(DebuggerMessage.MESSAGE_PREFIX)



func _on_settings_updated(key: String, data: Array) -> bool:

    settings_updated.emit(data[0], data[1], data[2])

    return true
