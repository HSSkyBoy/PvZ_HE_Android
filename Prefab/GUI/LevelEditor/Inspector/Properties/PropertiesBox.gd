class_name PropertiesBox extends VBoxContainer

signal value_changed(key: StringName, new_value: Variant)
signal number_changed(key: StringName, new_value: float)
signal string_changed(key: StringName, new_value: String)
signal bool_changed(key: StringName, new_value: bool)
signal color_changed(key: StringName, new_value: Color)
signal vector2_changed(key: StringName, new_value: Vector2)
signal vector4i_changed(key: StringName, new_value: Vector4i)
signal array_changed(key: StringName, new_value: Array)
signal array_vector2_changed(key: StringName, new_value: Array[Vector2])

const ICON_RELOAD = preload("uid://b261mqo4crf07")

const PROPERTIES_CONTAINER = preload("uid://dvx0agv2rta6e")

const PROPERTIES_BOOL = preload("uid://drg0fi23ifge4")
const PROPERTIES_INT = preload("uid://c43mrf03jpt2g")
const PROPERTIES_FLOAT = preload("uid://ce6nbs0h3lltc")
const PROPERTIES_STRING = preload("uid://m0ep8vt6fdbs")
const PROPERTIES_MULTILINE_STRING = preload("uid://bff45o7x3xb2u")
const PROPERTIES_VECTOR_2 = preload("uid://cbjrnlebs22v0")
const PROPERTIES_COLOR = preload("uid://ca1dcepidnu8m")
const PROPERTIES_ENUM = preload("uid://c4cxl5ec7iret")
const PROPERTIES_FLAG = preload("uid://dwohqr20egmxg")
const PROPERTIES_ARRAY = preload("uid://b6pvi03p7a6nj")
const PROPERTIES_ARRAY_VECTOR2 = preload("uid://s2ng0og2b627")

const PROPERTIES_VECTOR_4I = preload("uid://dkwhkpg0ys0sj")
@export var _group_indent: = 8.0

var _keys: = {}
var _group_stack: = []

func clear():
    for x in get_children():
        x.queue_free()

    _keys.clear()
    _group_stack.clear()

func add_bool(obj: Object, propertyName: String, key: StringName, value: bool = false, rest_value: Variant = false):
    var editor = PROPERTIES_BOOL.instantiate() as PropertiesBool
    _add_property_editor(key, editor, editor.value_changed, _on_bool_changed, rest_value)
    editor.value = value
    editor.obj = obj
    editor.propertyName = propertyName
    return editor

func add_int(obj: Object, propertyName: String, key: StringName, value: int = 0, rest_value: Variant = 0):
    var editor = PROPERTIES_INT.instantiate() as PropertiesInt
    _add_property_editor(key, editor, editor.value_changed, _on_number_changed, rest_value)
    editor.value = value
    editor.obj = obj
    editor.propertyName = propertyName
    return editor

func add_float(obj: Object, propertyName: String, key: StringName, value: float = 0.0, rest_value: Variant = 0.0):
    var editor = PROPERTIES_FLOAT.instantiate() as PropertiesFloat
    _add_property_editor(key, editor, editor.value_changed, _on_number_changed, rest_value)
    editor.value = value
    editor.obj = obj
    editor.propertyName = propertyName
    return editor

func add_string(obj: Object, propertyName: String, key: StringName, value: String = "", rest_value: Variant = "", isMultiline: bool = false):
    var editor
    if !isMultiline:
        editor = PROPERTIES_STRING.instantiate() as PropertiesString
    else:
        editor = PROPERTIES_MULTILINE_STRING.instantiate() as PropertiesMultilineString
    _add_property_editor(key, editor, editor.value_changed, _on_string_changed, rest_value, !isMultiline)
    editor.value = value
    editor.obj = obj
    editor.propertyName = propertyName
    return editor

func add_color(obj: Object, propertyName: String, key: StringName, value: Color = Color.BLACK, rest_value: Variant = Color.WHITE):
    var editor = PROPERTIES_COLOR.instantiate() as PropertiesColor
    _add_property_editor(key, editor, editor.value_changed, _on_color_changed, rest_value)
    editor.value = value
    editor.obj = obj
    editor.propertyName = propertyName
    return editor

func add_vector2(obj: Object, propertyName: String, key: StringName, value: Vector2 = Vector2.ZERO, rest_value: Variant = Vector2.ZERO):
    var editor = PROPERTIES_VECTOR_2.instantiate() as PropertiesVector2
    _add_property_editor(key, editor, editor.value_changed, _on_vector2_changed, rest_value)
    editor.value = value
    editor.obj = obj
    editor.propertyName = propertyName
    return editor

func add_vector4i(obj: Object, propertyName: String, key: StringName, value: Vector4i = Vector4i.ZERO, rest_value: Variant = Vector4i.ZERO):
    var editor = PROPERTIES_VECTOR_4I.instantiate() as PropertiesVector4i
    _add_property_editor(key, editor, editor.value_changed, _on_vector4i_changed, rest_value)
    editor.value = value
    editor.obj = obj
    editor.propertyName = propertyName
    return editor

func add_enum(obj: Object, propertyName: String, key: StringName, hint: Variant, value: Variant, rest_value: Variant):
    var editor = PROPERTIES_ENUM.instantiate() as PropertiesEnum
    _add_property_editor(key, editor, editor.value_changed, _on_value_changed, rest_value)
    if hint is Dictionary:
        var dictionary = {}
        for hintEnumId: int in range(hint.keys().size()):
            var hintKey = hint.keys()[hintEnumId]
            dictionary[hintKey] = hint[hintKey]
        editor.hintDictionary = dictionary
    if hint is Array:
        var dictionary = {}
        for hintEnumId: int in range(hint.size()):
            var hintKey = hint[hintEnumId]
            dictionary[hintKey] = hintEnumId
        editor.hintDictionary = dictionary
    editor.value = value
    editor.obj = obj
    editor.propertyName = propertyName
    return editor

func add_flag(obj: Object, propertyName: String, key: StringName, hint: Variant, value: int = 0, rest_value: Variant = 0):
    var editor = PROPERTIES_FLAG.instantiate() as PropertiesFlag
    _add_property_editor(key, editor, editor.value_changed, _on_number_changed, rest_value)
    editor.hintDictionary = hint
    editor.value = value
    editor.obj = obj
    editor.propertyName = propertyName
    return editor

func add_array(obj: Object, propertyName: String, key: StringName, hint: Variant, hintType: String, value: Array = [], rest_value: Variant = Color.WHITE):
    var editor = PROPERTIES_ARRAY.instantiate() as PropertiesArray
    _add_property_editor(key, editor, editor.value_changed, _on_array_changed, rest_value, false)
    editor.hint = hint
    editor.hintType = hintType
    editor.value = value
    editor.obj = obj
    editor.propertyName = propertyName

    return editor

func add_array_vector2(obj: Object, propertyName: String, key: StringName, value: Array[Vector2] = [], rest_value: Variant = []):
    var editor = PROPERTIES_ARRAY_VECTOR2.instantiate() as PropertiesArrayVector2
    _add_property_editor(key, editor, editor.value_changed, _on_array_vector2_changed, rest_value, false)
    editor.value = value
    editor.obj = obj
    editor.propertyName = propertyName

    return editor

func add_group(label: String):
    var title = Button.new()
    var outer_box = VBoxContainer.new()
    var offset_box = HBoxContainer.new()
    var offset = Control.new()
    var inner_box = VBoxContainer.new()

    title.focus_mode = Control.FOCUS_NONE
    title.text = label
    title.toggle_mode = true
    title.button_pressed = true
    title.alignment = HORIZONTAL_ALIGNMENT_LEFT
    title.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
    title.icon = get_theme_icon("arrow", "Tree")
    title.add_theme_font_size_override("font_size", 16)
    title.toggled.connect(offset_box.set_visible)
    title.light_mask = 0
    offset_box.size_flags_horizontal = SIZE_EXPAND_FILL
    offset_box.add_theme_constant_override("separation", 0)
    offset_box.light_mask = 0
    offset.custom_minimum_size = Vector2(_group_indent, 0)
    offset.light_mask = 0
    inner_box.size_flags_horizontal = SIZE_EXPAND_FILL
    inner_box.light_mask = 0

    outer_box.add_child(title)
    outer_box.add_child(offset_box)
    outer_box.light_mask = 0
    offset_box.add_child(offset)
    offset_box.add_child(inner_box)
    _get_box().add_child(outer_box)

    _group_stack.append(inner_box)

func end_group():
    if _group_stack.size() >= 1:
        _group_stack.remove_at(_group_stack.size() - 1)

func delete_value(key: StringName) -> void :
    var editor = _keys[key]
    _keys.erase(key)
    editor.container.queue_free()
    editor.queue_free()

func get_value(key: StringName) -> Variant:
    var editor = _keys[key]
    if editor is PropertiesBase:
        return editor.value
    return editor

func get_bool(key: StringName) -> bool:
    var editor = _keys[key]
    return editor.value

func get_int(key: StringName) -> int:
    var editor = _keys[key]
    return editor.value

func get_float(key: StringName) -> float:
    var editor = _keys[key]
    return editor.value

func get_string(key: StringName) -> String:
    var editor = _keys[key]
    return editor.value

func get_color(key: StringName) -> float:
    var editor = _keys[key]
    return editor.color

func get_vector2(key: StringName) -> float:
    var editor = _keys[key]
    return editor.value

func get_option(key: StringName) -> int:
    return get_int(key)

func _get_box() -> Control:
    if _group_stack.size() == 0:
        return self
    else:
        return _group_stack[_group_stack.size() - 1]

func set_value(key: StringName, value: Variant) -> void :
    if _keys.has(key):
        var editor = _keys[key]
        if editor.has_focus():
            return
        if editor is PropertiesBool:
            editor.value_changed.disconnect(_on_bool_changed)
            editor.value = value
            editor.value_changed.connect(_on_bool_changed.bind(key))
            return
        elif editor is PropertiesInt:
            editor.value_changed.disconnect(_on_number_changed)
            editor.value = value
            editor.value_changed.connect(_on_number_changed.bind(key))
            return
        elif editor is PropertiesFloat:
            editor.value_changed.disconnect(_on_number_changed)
            editor.value = value
            editor.value_changed.connect(_on_number_changed.bind(key))
            return
        elif editor is PropertiesString:
            editor.value_changed.disconnect(_on_string_changed)
            editor.value = value
            editor.value_changed.connect(_on_string_changed.bind(key))
            return
        elif editor is PropertiesMultilineString:
            editor.value_changed.disconnect(_on_string_changed)
            editor.value = value
            editor.value_changed.connect(_on_string_changed.bind(key))
            return
        elif editor is PropertiesVector2:
            editor.value_changed.disconnect(_on_vector2_changed)
            editor.value = value
            editor.value_changed.connect(_on_vector2_changed.bind(key))
            return
        elif editor is PropertiesVector4i:
            editor.value_changed.disconnect(_on_vector4i_changed)
            editor.value = value
            editor.value_changed.connect(_on_vector4i_changed.bind(key))
            return
        elif editor is PropertiesColor:
            editor.value_changed.disconnect(_on_color_changed)
            editor.value = value
            editor.value_changed.connect(_on_color_changed.bind(key))
            return
        elif editor is PropertiesEnum:
            editor.value_changed.disconnect(_on_value_changed)
            editor.value = value
            editor.value_changed.connect(_on_value_changed.bind(key))
            return
        elif editor is PropertiesFlag:
            editor.value_changed.disconnect(_on_number_changed)
            editor.value = value
            editor.value_changed.connect(_on_number_changed.bind(key))
            return
        elif editor is PropertiesArray:
            editor.value_changed.disconnect(_on_array_changed)
            editor.value = value
            editor.value_changed.connect(_on_array_changed.bind(key))
            return
        elif editor is PropertiesArrayVector2:
            editor.value_changed.disconnect(_on_array_vector2_changed)
            editor.value = value
            editor.value_changed.connect(_on_array_vector2_changed.bind(key))
            return

func _add_property_editor(key: StringName, editor: Control, editor_signal: Signal, signal_handler: Callable, rest_value: Variant = null, inner: bool = true):
    _keys[key] = editor
    editor.key = key
    editor.propertiesBox = self
    var box = PROPERTIES_CONTAINER.instantiate() as LevelEditorPropertiesContainer
    editor.container = box
    _get_box().add_child(box)
    if inner:
        editor.size_flags_horizontal = SIZE_EXPAND_FILL
        box.innerContainer.add_child(editor)
    else:
        editor.size_flags_vertical = SIZE_EXPAND_FILL
        box.outerContainer.add_child(editor)
    box.keyLabel.text = key
    box.restValue = rest_value
    box.propertyEditor = editor
    if rest_value != null:
        box.refreshButton.pressed.connect(signal_handler.bind(rest_value, key))

    editor_signal.connect(signal_handler.bind(key))

func _on_value_changed(value: Variant, key: StringName):
    value_changed.emit(key, value)

func _on_number_changed(value: float, key: StringName):
    number_changed.emit(key, value)
    value_changed.emit(key, value)

func _on_string_changed(value: String, key: StringName):
    string_changed.emit(key, value)
    value_changed.emit(key, value)

func _on_bool_changed(value: bool, key: StringName):
    bool_changed.emit(key, value)
    value_changed.emit(key, value)

func _on_color_changed(value: Color, key: StringName):
    color_changed.emit(key, value)
    value_changed.emit(key, value)

func _on_vector2_changed(value: Vector2, key: StringName):
    vector2_changed.emit(key, value)
    value_changed.emit(key, value)

func _on_vector4i_changed(value: Vector4i, key: StringName):
    vector4i_changed.emit(key, value)
    value_changed.emit(key, value)

func _on_array_changed(value: Array, key: StringName):
    array_changed.emit(key, value)
    value_changed.emit(key, value)

func _on_array_vector2_changed(value: Array[Vector2], key: StringName):
    array_vector2_changed.emit(key, value)
    value_changed.emit(key, value)
