class_name LevelEditorEventEditor extends Control

@onready var initLevelEventListContainer: ScrollContainer = %InitLevelEventListContainer
@onready var readyLevelEventListContainer: ScrollContainer = %ReadyLevelEventListContainer
@onready var startEventListContainer: ScrollContainer = %StartEventListContainer

@onready var inspector: MapEditorInspector = %LevelEditorInspector

@export var levelConfig: TowerDefenseLevelConfig

static  var instance: LevelEditorEventEditor

func Clear() -> void :
    initLevelEventListContainer.Clear()
    readyLevelEventListContainer.Clear()
    startEventListContainer.Clear()
    inspector.Clear()

func Init(_levelConfig: TowerDefenseLevelConfig) -> void :
    Clear()
    levelConfig = _levelConfig
    initLevelEventListContainer.Init(levelConfig.eventInit)
    readyLevelEventListContainer.Init(levelConfig.eventReady)
    startEventListContainer.Init(levelConfig.eventStart)
    inspector.Clear()

func Save() -> void :
    if !is_instance_valid(levelConfig):
        return
    levelConfig.eventInit = initLevelEventListContainer.GetEventList()
    levelConfig.eventReady = readyLevelEventListContainer.GetEventList()
    levelConfig.eventStart = startEventListContainer.GetEventList()

func _ready() -> void :
    instance = self

func InitEventChange() -> void :
    levelConfig.canExport = false
    levelConfig.eventInit = initLevelEventListContainer.GetEventList()
    inspector.Clear()

func ReadyEventChange() -> void :
    levelConfig.canExport = false
    levelConfig.eventReady = readyLevelEventListContainer.GetEventList()
    inspector.Clear()

func StartEventChange() -> void :
    levelConfig.canExport = false
    levelConfig.eventStart = startEventListContainer.GetEventList()
    inspector.Clear()
