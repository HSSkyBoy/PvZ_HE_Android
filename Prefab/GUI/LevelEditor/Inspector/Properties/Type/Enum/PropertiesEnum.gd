class_name PropertiesEnum extends PropertiesBase

@onready var optionButton: OptionButton = %OptionButton

signal value_changed(_value: Variant)

var itemDictionary: Dictionary = {}

var hintDictionary: Dictionary = {}:
    set(_hintDictionary):
        if is_node_ready():
            hintDictionary = _hintDictionary
            itemDictionary.clear()
            for hint: String in hintDictionary.keys():
                itemDictionary[hintDictionary[hint]] = hint
                optionButton.add_item(hint)

var value: Variant = false:
    set(_value):
        if is_node_ready():
            value = _value
            optionButton.item_selected.disconnect(ValueChange)
            optionButton.selected = FindOptionButtonId(optionButton, itemDictionary[value])
            optionButton.item_selected.connect(ValueChange)

func ValueChange(index: Variant):
    value = hintDictionary[optionButton.get_item_text(index)]
    value_changed.emit(value)

func CanSetValue() -> bool:
    return !optionButton.has_focus()

func GetType() -> String:
    return "Enum"

func FindOptionButtonId(_optionButton: OptionButton, _key: String) -> int:
    for index in _optionButton.item_count:
        if _optionButton.get_item_text(index) == _key:
            return _optionButton.get_item_id(index)
    return -1
