extends PanelContainer

@onready var eventOptionButton: OptionButton = %EventOptionButton

signal change()

var inspector: MapEditorInspector
var eventConfig: TowerDefenseLevelEventBase

func Init(_eventConfig: TowerDefenseLevelEventBase) -> void :
    eventConfig = _eventConfig
    eventOptionButton.selected = FindOptionButtonId(eventOptionButton, eventConfig.GetName())

func _ready() -> void :
    for eventName in TowerDefenseLevelEventMathine.eventList:
        eventOptionButton.add_item(eventName)

func UpButtonPressed() -> void :
    if get_index() > 0:
        get_parent().move_child(self, get_index() - 1)
    change.emit()

func DeleteButtonPressed() -> void :
    queue_free()
    change.emit()

func SettingButtonPressed() -> void :
    change.emit()
    if eventOptionButton.selected != -1:
        inspector.Init(eventConfig, eventConfig.GetProperty())

func EventOptionButtonItemSelected(index: int) -> void :
    eventConfig = TowerDefenseLevelEventMathine.EventGet(TowerDefenseLevelEventMathine.eventList[eventOptionButton.get_item_text(index)])
    SettingButtonPressed()

func FindOptionButtonId(optionButton: OptionButton, key: String) -> int:
    for index in optionButton.item_count:
        if optionButton.get_item_text(index) == key:
            return optionButton.get_item_id(index)
    return -1
