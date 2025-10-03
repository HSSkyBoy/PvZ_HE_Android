class_name MapEditorInspector extends PanelContainer

@export var title: String = "检查器"

@onready var titleLabel: Label = %TitleLabel

@onready var propertiesBox: PropertiesBox = %PropertiesBox

var nowCheckDictionary: Dictionary = {}
var nowObj: Object = null

func Init(obj: Object, propertiesData: Dictionary) -> void :
    ReFresh(propertiesData)
    nowObj = obj

func ReFresh(propertiesData: Dictionary) -> void :
    Clear()
    for propertiesGroupName: String in propertiesData.keys():
        var propertiesDictionary: Dictionary = propertiesData[propertiesGroupName]
        propertiesBox.add_group(propertiesGroupName)
        nowCheckDictionary.merge(propertiesDictionary)
        for propertiesShowName: String in propertiesDictionary.keys():
            AddProperty(propertiesDictionary[propertiesShowName], propertiesShowName, propertiesGroupName + "/" + propertiesShowName)
        propertiesBox.end_group()

func _ready() -> void :
    titleLabel.text = title

@warning_ignore("unused_parameter")
func _process(delta: float) -> void :
    pass

func AddProperty(properties: Dictionary, propertiesShowName: String, path: String = "") -> PropertiesBase:
    nowCheckDictionary.get_or_add(propertiesShowName, properties)
    var object = properties["Object"]
    var type = properties["Type"]
    var propertyName: String = properties["Property"]
    var rest: Variant = null
    if properties.has("Rest"):
        rest = properties["Rest"]
    var property: Variant = object.get_indexed(propertyName)
    var isTargetObject: bool = true
    var close: Variant = false
    if property is Dictionary:
        property = property[propertiesShowName]
        isTargetObject = false
        close = true
    if properties.has("Close"):
        close = properties["Close"]
    var editor: PropertiesBase
    match type:
        "Bool":
            editor = propertiesBox.add_bool(object, propertyName, propertiesShowName, property, rest)
        "Int":
            editor = propertiesBox.add_int(object, propertyName, propertiesShowName, property, rest)
        "Float":
            editor = propertiesBox.add_float(object, propertyName, propertiesShowName, property, rest)
        "String":
            editor = propertiesBox.add_string(object, propertyName, propertiesShowName, property, rest)
        "MultilineString":
            editor = propertiesBox.add_string(object, propertyName, propertiesShowName, property, rest, true)
        "Color":
            if typeof(rest) == TYPE_STRING:
                rest = GetParseValue("Color", rest)
            editor = propertiesBox.add_color(object, propertyName, propertiesShowName, property, rest)
        "Vector2":
            if typeof(rest) == TYPE_STRING:
                rest = GetParseValue("Vector2", rest)
            editor = propertiesBox.add_vector2(object, propertyName, propertiesShowName, property, rest)
        "Vector4i":
            editor = propertiesBox.add_vector4i(object, propertyName, propertiesShowName, property, rest)
        "Enum":
            var hint = properties["Hint"]
            editor = propertiesBox.add_enum(object, propertyName, propertiesShowName, hint, property, rest)
        "Flag":
            var hint = properties["Hint"]
            editor = propertiesBox.add_flag(object, propertyName, propertiesShowName, hint, property, rest)
        "File":
            var hint = properties["Hint"]
            editor = propertiesBox.add_file_select(object, propertyName, propertiesShowName, hint, property, rest)
        "Map":
            editor = propertiesBox.add_map_select(object, propertyName, propertiesShowName, property, rest)
        "Room":
            var hint = properties["Hint"]
            editor = propertiesBox.add_room_select(object, propertyName, propertiesShowName, hint, property, rest)
        "Array":
            var hint = ""
            if properties.has("Hint"):
                hint = properties["Hint"]
            var hintType = properties["HintType"]
            editor = propertiesBox.add_array(object, propertyName, propertiesShowName, hint, hintType, object.get_indexed(propertyName), rest)
        "ArrayVector2":
            editor = propertiesBox.add_array_vector2(object, propertyName, propertiesShowName, property, rest)
    editor.isTargetObj = isTargetObject
    editor.inspector = self
    editor.path = path
    editor.showCloseButton = close

    return editor

static func GetRestValue(type: String) -> Variant:
    match type:
        "Bool":
            return false
        "Int":
            return 0
        "Float":
            return 0.0
        "String":
            return ""
        "Color":
            return Color.WHITE
        "Vector2":
            return Vector2.ZERO
        "Array":
            return []
        "ArrayVector2":
            return []
    return null

static func GetCanParseValue(type: String) -> bool:
    match type:
        "Bool":
            return true
        "Int":
            return true
        "Float":
            return true
        "String":
            return true
        "Color":
            return true
        "Vector2":
            return true
        "Array":
            return false
        "ArrayVector2":
            return false
    return false

static func GetParseValue(type: String, _str: String) -> Variant:
    match type:
        "Bool":
            return _str == "true"
        "Int":
            return _str.to_int()
        "Float":
            return _str.to_float()
        "String":
            return _str
        "Color":
            var arr = _str.split_floats(",", false)
            return Color(arr[0], arr[1], arr[2], arr[3])
        "Vector2":
            var arr = _str.split_floats(",", false)
            return Vector2(arr[0], arr[1])

    return null

static func GetTypeString(value: Variant) -> String:
    match typeof(value):
        TYPE_BOOL:
            return "Bool"
        TYPE_INT:
            return "Int"
        TYPE_FLOAT:
            return "Float"
        TYPE_STRING:
            return "String"
        TYPE_COLOR:
            return "Color"
        TYPE_VECTOR2:
            return "Vector2"
        TYPE_ARRAY:

            if value.size() > 0 and typeof(value[0]) == TYPE_VECTOR2:
                return "ArrayVector2"
            return "Array"
    return ""

func Clear() -> void :
    nowObj = null
    propertiesBox.clear()
    nowCheckDictionary.clear()

func ChangeValue(key: StringName, newValue: Variant) -> void :
    var propertyData: Dictionary = nowCheckDictionary[key]
    var object = propertyData["Object"] as Object
    var propertyName: String = propertyData["Property"]
    var editor: PropertiesBase = propertiesBox._keys[key]
    var property = object.get_indexed(propertyName)
    if !editor.isTargetObj:
        property[key] = newValue
    else:
        object.set_indexed(propertyName, newValue)
    if propertyData.has("Set"):
        propertyData["Set"].call()
