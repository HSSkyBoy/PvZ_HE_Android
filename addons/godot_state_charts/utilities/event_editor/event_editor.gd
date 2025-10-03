@tool
extends EditorProperty

const StateChartUtil = preload("../state_chart_util.gd")
var _refactor_window_scene: PackedScene = preload("../event_refactor/event_refactor.tscn")



var _property_control: LineEdit = LineEdit.new()

var _dropdown_button: Button = Button.new()

var _popup_menu: PopupMenu = PopupMenu.new()


var _chart: StateChart

var _undo_redo: EditorUndoRedoManager


func _init(transition: Transition, undo_redo: EditorUndoRedoManager):


    _chart = StateChartUtil.find_parent_state_chart(transition)
    _undo_redo = undo_redo


    _popup_menu.index_pressed.connect(_on_event_selected)

    _dropdown_button.icon = get_theme_icon("arrow", "OptionButton")
    _dropdown_button.flat = true
    _dropdown_button.pressed.connect(_show_popup)


    var hbox: = HBoxContainer.new()
    hbox.add_child(_property_control)
    hbox.add_child(_dropdown_button)
    _property_control.size_flags_horizontal = Control.SIZE_EXPAND_FILL


    add_child(hbox)
    add_child(_popup_menu)


    add_focusable(_property_control)
    _property_control.text_changed.connect(_on_text_changed)


func _show_popup():

    var known_events = StateChartUtil.events_of(_chart)

    _popup_menu.clear()
    _popup_menu.add_item("<empty>")
    _popup_menu.add_icon_item(get_theme_icon("Tools", "EditorIcons"), "Manage...")

    if known_events.size() > 0:
        _popup_menu.add_separator()

    for event in known_events:
        _popup_menu.add_item(event)


    var gt: = _dropdown_button.get_global_rect()
    _popup_menu.reset_size()
    var ms: = _popup_menu.get_contents_minimum_size().x
    var popup_pos: = gt.end - Vector2(ms, 0) + Vector2(DisplayServer.window_get_position())
    _popup_menu.set_position(popup_pos)
    _popup_menu.popup()


func _on_event_selected(index: int) -> void :

    if index == 1:

        var window = _refactor_window_scene.instantiate()
        add_child(window)
        window.open(_chart, _undo_redo)
        return


    var event: = _popup_menu.get_item_text(index) if index > 0 else ""
    _property_control.text = event
    _on_text_changed(event)
    _property_control.grab_focus()


func _on_text_changed(new_text: String):
    emit_changed(get_edited_property(), new_text)


func _update_property() -> void :

    var new_value = get_edited_object()[get_edited_property()]


    if new_value == _property_control.text:
        return

    _property_control.text = new_value
