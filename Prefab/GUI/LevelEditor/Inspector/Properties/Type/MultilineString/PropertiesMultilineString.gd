class_name PropertiesMultilineString extends PropertiesBase

@onready var textEdit: TextEdit = %TextEdit

signal value_changed(_value: String)

var value: String = "":
    set(_value):
        if is_node_ready():
            value = _value
            if CanSetValue():
                textEdit.text_changed.disconnect(ValueChange)
                textEdit.text = value
                textEdit.text_changed.connect(ValueChange)

func _ready() -> void :
    value = textEdit.text

func ValueChange():
    value = textEdit.text
    value_changed.emit(value)

func CanSetValue() -> bool:
    return !textEdit.has_focus()

func GetType() -> String:
    return "String"
