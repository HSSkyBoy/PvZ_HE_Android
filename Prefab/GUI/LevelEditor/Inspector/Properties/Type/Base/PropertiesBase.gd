class_name PropertiesBase extends PanelContainer

signal delete(_propertyName: String, _key: String)

@onready var closeButton: Button = %CloseButton

var inspector: MapEditorInspector
var container: LevelEditorPropertiesContainer
var obj: Object = null
var propertyName: String = ""
var propertiesBox: PropertiesBox
var key: String

var path: String = ""

var isTargetObj: bool = true

var showCloseButton: bool = true

func _ready() -> void :
    pass

@warning_ignore("unused_parameter")
func _process(delta: float) -> void :
    if !visible:
        return
    if propertiesBox && obj && propertyName != "":
        if CanSetValue():
            var valueGet = GetValue()
            propertiesBox.set_value(key, valueGet)
            closeButton.visible = showCloseButton && !isTargetObj

func CanSetValue() -> bool:
    return true

func GetType() -> String:
    return ""

func GetObjName() -> String:
    if !isTargetObj:
        return ""
    return obj.name

func GetPropertyNameString() -> String:
    var valueGet = obj.get_indexed(propertyName)
    if isTargetObj:
        return key
    elif valueGet is Dictionary:
        return propertyName + "[%s]" % [key]
    elif valueGet is Array:
        return propertyName + "[%d]" % [key]
    else:
        return ""

func GetPropertyName() -> String:
    return propertyName

func GetKey() -> String:
    return key

func GetValue() -> Variant:
    var valueGet = obj.get_indexed(propertyName)
    if isTargetObj:
        return valueGet
    elif valueGet is Dictionary:
        return valueGet[key]
    elif valueGet is Array:
        return valueGet[key.to_int()]
    else:
        return null

func CloseButtonPressed() -> void :
    if isTargetObj:
        return
    var valueGet = obj.get_indexed(propertyName)
    if valueGet is Dictionary:
        valueGet.erase(key)
        delete.emit(propertyName, key)
    if valueGet is Array:
        valueGet.remove_at(key.to_int())
        delete.emit(propertyName, key.to_int())
    propertiesBox.delete_value(key)
