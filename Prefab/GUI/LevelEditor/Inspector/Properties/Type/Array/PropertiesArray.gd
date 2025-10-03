class_name PropertiesArray extends PropertiesBase

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

@onready var foldButton: Button = %FoldButton
@onready var foldContainer: VBoxContainer = %FoldContainer
@onready var propertiesContainer: VBoxContainer = %PropertiesContainer

signal value_changed(_value: Array)

var hintType: String = "Int"
var hint: Variant

var boxList: Array[LevelEditorPropertiesContainer] = []

var timer: float = 0.0

var value: Array = []:
    set(_value):
        if is_node_ready():
            value = _value
            foldButton.text = "数组( 大小 %d )" % [value.size()]
            for box in boxList:
                if box:
                    box.queue_free()
            boxList.clear()
            for valueId in range(value.size()):
                var valueGet = value[valueId]
                AddEditor(valueId, valueGet)




func ValueChange(_value: Variant):
    var getValue: Array = []
    for box: LevelEditorPropertiesContainer in boxList:
        getValue.append(box.propertyEditor.value)
    value = getValue
    value_changed.emit(value)

func CanSetValue() -> bool:
    for box in boxList:
        if !box.propertyEditor.CanSetValue():
            return false
    timer += get_process_delta_time()
    if timer > 0.2:
        timer = 0.0
        return true
    return false

func FoldButtonPressed() -> void :
    foldContainer.visible = foldButton.button_pressed

func AddButtonPressed() -> void :
    AddEditor(value.size(), null)
    ValueChange(null)

func AddEditor(id: int, _value: Variant) -> void :
    match hintType:
        "Bool":
            AddBool(id, _value)
        "Int":
            AddInt(id, _value)
        "Float":
            AddFloat(id, _value)
        "String":
            AddString(id, _value)
        "MultilineString":
            AddMultilineString(id, _value)
        "Vector2":
            AddVector2(id, _value)
        "Color":
            AddColor(id, _value)
        "Enum":
            AddEnum(id, _value)
        "Flag":
            AddFlag(id, _value)
        "Array":
            AddArray(id, _value)

func AddPropertyEditor(index: int, _value: Variant, editor: Control, inner: bool = true) -> void :
    var box = PROPERTIES_CONTAINER.instantiate() as LevelEditorPropertiesContainer
    editor.isTargetObj = false
    propertiesContainer.add_child(box)
    boxList.append(box)
    if inner:
        editor.size_flags_horizontal = SIZE_EXPAND_FILL
        box.innerContainer.add_child(editor)
    else:
        editor.size_flags_vertical = SIZE_EXPAND_FILL
        box.outerContainer.add_child(editor)
    box.restValue = null
    box.keyLabel.text = str(index)
    box.propertyEditor = editor

    editor.obj = obj
    editor.propertyName = propertyName
    editor.value_changed.connect(ValueChange)

func AddBool(index: int, _value: Variant = false) -> PropertiesBool:
    if _value == null:
        _value = false
    var editor = PROPERTIES_BOOL.instantiate() as PropertiesBool
    AddPropertyEditor(index, _value, editor)
    editor.value = _value
    return editor

func AddInt(index: int, _value: Variant = 0) -> PropertiesInt:
    if _value == null:
        _value = 0
    var editor = PROPERTIES_INT.instantiate() as PropertiesInt
    AddPropertyEditor(index, _value, editor)
    editor.value = _value
    return editor

func AddFloat(index: int, _value: Variant = 0.0) -> PropertiesFloat:
    if _value == null:
        _value = 0.0
    var editor = PROPERTIES_FLOAT.instantiate() as PropertiesFloat
    AddPropertyEditor(index, _value, editor)
    editor.value = _value
    return editor

func AddString(index: int, _value: Variant = "") -> PropertiesString:
    if _value == null:
        _value = ""
    var editor = PROPERTIES_STRING.instantiate() as PropertiesString
    AddPropertyEditor(index, _value, editor)
    editor.value = _value
    return editor

func AddMultilineString(index: int, _value: Variant = "") -> PropertiesMultilineString:
    if _value == null:
        _value = ""
    var editor = PROPERTIES_MULTILINE_STRING.instantiate() as PropertiesMultilineString
    AddPropertyEditor(index, _value, editor, false)
    editor.value = _value
    return editor

func AddVector2(index: int, _value: Variant = Vector2.ZERO) -> PropertiesVector2:
    if _value == null:
        _value = Vector2.ZERO
    var editor = PROPERTIES_VECTOR_2.instantiate() as PropertiesVector2
    AddPropertyEditor(index, _value, editor)
    editor.value = _value
    return editor

func AddColor(index: int, _value: Variant = Color.BLACK) -> PropertiesColor:
    if _value == null:
        _value = Color.BLACK
    var editor = PROPERTIES_COLOR.instantiate() as PropertiesColor
    AddPropertyEditor(index, _value, editor)
    editor.value = _value
    return editor

func AddEnum(index: int, _value: Variant = 0) -> PropertiesEnum:
    if _value == null:
        _value = 0
    var editor = PROPERTIES_ENUM.instantiate() as PropertiesEnum
    AddPropertyEditor(index, _value, editor)
    if hint is Dictionary:
        var dictionary = {}
        for hintEnumId: int in range(hint.keys().size()):
            var hintKey = hint.keys()[hintEnumId]
            if hint[hintKey] is int:
                dictionary[hintKey] = hint[hintKey]
            if hint[hintKey] is String:
                dictionary[hintKey] = hintEnumId
        editor.hintDictionary = dictionary
    if hint is Array:
        var dictionary = {}
        for hintEnumId: int in range(hint.size()):
            var hintKey = hint[hintEnumId]
            dictionary[hintKey] = hintEnumId
        editor.hintDictionary = dictionary
    editor.value = _value
    return editor

func AddFlag(index: int, _value: Variant = 0) -> PropertiesFlag:
    if _value == null:
        _value = 0
    var editor = PROPERTIES_FLAG.instantiate() as PropertiesFlag
    AddPropertyEditor(index, _value, editor)
    editor.hintDictionary = hint
    editor.value = _value
    return editor

func AddArray(index: int, _value: Variant = []) -> PropertiesArray:
    if _value == null:
        _value = []
    var editor = PROPERTIES_ARRAY.instantiate() as PropertiesArray
    AddPropertyEditor(index, _value, editor, false)
    editor.hintType = hintType
    editor.value = _value
    return editor
