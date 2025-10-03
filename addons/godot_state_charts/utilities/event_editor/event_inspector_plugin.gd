@tool
extends EditorInspectorPlugin

const EventEditor = preload("event_editor.gd")

var _undo_redo: EditorUndoRedoManager


func setup(undo_redo: EditorUndoRedoManager):
    _undo_redo = undo_redo


func _can_handle(_object):

    return true


func _parse_property(object, type, name, _hint_type, _hint_string, _usage_flags, _wide):

    if object is Transition and name == "event" and type == TYPE_STRING_NAME:


        var editor = EventEditor.new(object as Transition, _undo_redo)
        add_property_editor(name, editor)


        return true
    else:
        return false
