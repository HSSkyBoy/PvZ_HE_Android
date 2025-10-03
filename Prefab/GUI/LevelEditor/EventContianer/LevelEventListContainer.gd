extends ScrollContainer

const LEVEL_EVENT_CONTIANER = preload("uid://b617wjctwpjyw")

@onready var eventContainer: VBoxContainer = %EventContainer

@export var inspector: MapEditorInspector
signal change()

var isInit: bool = false

func Init(eventList: Array[TowerDefenseLevelEventBase]) -> void :
    isInit = true
    Clear()
    for eventConfig in eventList:
        AddEvent(eventConfig)
    isInit = false

func Clear() -> void :
    for event in eventContainer.get_children():
        event.queue_free()

func AddEvent(eventConfig: TowerDefenseLevelEventBase = null) -> void :
    var event = LEVEL_EVENT_CONTIANER.instantiate()
    eventContainer.add_child(event)
    event.inspector = inspector
    event.change.connect(Change)
    if eventConfig:
        event.Init(eventConfig)
    else:
        event.Init(TowerDefenseLevelEventMathine.EventGet("TipsPlay"))
    Change()

func Change() -> void :
    if !isInit:
        change.emit()

func GetEventList() -> Array[TowerDefenseLevelEventBase]:
    var eventList: Array[TowerDefenseLevelEventBase] = []
    for event in eventContainer.get_children():
        eventList.append(event.eventConfig)
    return eventList
