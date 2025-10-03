
extends EditorDebuggerPlugin


const DebuggerMessage = preload("editor_debugger_message.gd")
const DebuggerUI = preload("editor_debugger.gd")


var _debugger_ui_scene: PackedScene = preload("editor_debugger.tscn")


var _settings: EditorSettings = null

func initialize(settings: EditorSettings):
    _settings = settings

func _has_capture(prefix):
    return prefix == DebuggerMessage.MESSAGE_PREFIX

func _capture(message, data, session_id):
    var ui: DebuggerUI = get_session(session_id).get_meta("__state_charts_debugger_ui")
    match (message):
        DebuggerMessage.STATE_CHART_EVENT_RECEIVED_MESSAGE:
            ui.event_received(data[0], data[1], data[2])
        DebuggerMessage.STATE_CHART_ADDED_MESSAGE:
            ui.add_chart(data[0])
        DebuggerMessage.STATE_CHART_REMOVED_MESSAGE:
            ui.remove_chart(data[0])
        DebuggerMessage.STATE_UPDATED_MESSAGE:
            ui.update_state(data[0], data[1])
        DebuggerMessage.STATE_CHART_EVENT_RECEIVED_MESSAGE:
            ui.event_received(data[0], data[1], data[2])
        DebuggerMessage.STATE_ENTERED_MESSAGE:
            ui.state_entered(data[0], data[1], data[2])
        DebuggerMessage.STATE_EXITED_MESSAGE:
            ui.state_exited(data[0], data[1], data[2])
        DebuggerMessage.TRANSITION_PENDING_MESSAGE:
            ui.transition_pending(data[0], data[1], data[2], data[3], data[4])
        DebuggerMessage.TRANSITION_TAKEN_MESSAGE:
            ui.transition_taken(data[0], data[1], data[2], data[3], data[4])

    return true

func _setup_session(session_id):

    var session = get_session(session_id)

    var debugger_ui: DebuggerUI = _debugger_ui_scene.instantiate()

    session.add_session_tab(debugger_ui)
    session.stopped.connect(debugger_ui.clear)
    session.set_meta("__state_charts_debugger_ui", debugger_ui)
    debugger_ui.initialize(_settings, session)
