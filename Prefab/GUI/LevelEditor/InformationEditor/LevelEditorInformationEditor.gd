class_name LevelEditorInformationEditor extends Control

@onready var levelNumberSpinBox: SpinBox = %LevelNumberSpinBox
@onready var levelNameLineEdit: LineEdit = %LevelNameLineEdit
@onready var levelDescriptionTextEdit: TextEdit = %LevelDescriptionTextEdit
@onready var homeWorldOptionButton: OptionButton = %HomeWorldOptionButton
@onready var mapOptionButton: OptionButton = %MapOptionButton
@onready var bgmOptionButton: OptionButton = %BgmOptionButton
@onready var talkOptionButton: OptionButton = %TalkOptionButton
@onready var talkCheckBox: CheckBox = %TalkCheckBox
@onready var tutorialOptionButton: OptionButton = %TutorialOptionButton
@onready var tutorialCheckBox: CheckBox = %TutorialCheckBox
@onready var mowerUseCheckBox: CheckBox = %MowerUseCheckBox

@onready var mapTexture: TextureRect = %MapTexture

@export var levelConfig: TowerDefenseLevelConfig

static  var instance: LevelEditorInformationEditor

var homeWorldTranslate: Dictionary = {
    GeneralEnum.HOMEWORLD.NOONE: "无", 
    GeneralEnum.HOMEWORLD.MORDEN: "现代"
}
var homeWorldDictionary: Dictionary = {
    "现代": GeneralEnum.HOMEWORLD.MORDEN, 
    "无": GeneralEnum.HOMEWORLD.NOONE
}

var mapDictionary: Dictionary = {}
var bgmDictionary: Dictionary = {}
var talkDictionary: Dictionary = {}
var tutorialDictionary: Dictionary = {}

var graveStoneDictionary: Dictionary = {}

var isInit: bool = false

func Init(_levelConfig: TowerDefenseLevelConfig) -> void :
    isInit = true
    levelConfig = _levelConfig
    levelNumberSpinBox.value = levelConfig.levelNumber
    levelNameLineEdit.text = levelConfig.levelName
    levelDescriptionTextEdit.text = levelConfig.description
    mowerUseCheckBox.button_pressed = levelConfig.mowerUse
    homeWorldOptionButton.selected = FindOptionButtonId(homeWorldOptionButton, homeWorldTranslate[levelConfig.homeWorld])
    var map: TowerDefenseMapConfig = ResourceManager.MAPS[levelConfig.map]
    mapOptionButton.selected = FindOptionButtonId(mapOptionButton, map.translate)
    MapOptionButtonItemSelected(mapOptionButton.selected)
    var bgm: TowerDefenseBackgroundMusicConfig = ResourceManager.BGMS[levelConfig.backgroundMusic]
    bgmOptionButton.selected = FindOptionButtonId(bgmOptionButton, bgm.translate)
    talkOptionButton.selected = FindOptionButtonId(talkOptionButton, levelConfig.talk)
    tutorialOptionButton.selected = FindOptionButtonId(tutorialOptionButton, levelConfig.tutorial)

    talkCheckBox.button_pressed = levelConfig.isCustomTalk
    tutorialCheckBox.button_pressed = levelConfig.isCustomTutorial
    isInit = false

func Clear() -> void :
    levelConfig = null

func _ready() -> void :
    instance = self
    for homeWorld in GeneralEnum.HOMEWORLD.values():
        homeWorldOptionButton.add_item(homeWorldTranslate[homeWorld])

    for mapKey: String in ResourceManager.MAPS.keys():
        var map: TowerDefenseMapConfig = ResourceManager.MAPS[mapKey]
        mapOptionButton.add_item(map.translate)
        mapDictionary[map.translate] = mapKey

    for bgmKey in ResourceManager.BGMS.keys():
        var bgm: TowerDefenseBackgroundMusicConfig = ResourceManager.BGMS[bgmKey]
        bgmOptionButton.add_item(bgm.translate)
        bgmDictionary[bgm.translate] = bgmKey

    for talk in ResourceManager.TALKS.keys():
        talkOptionButton.add_item(talk)

    for tutorial in ResourceManager.TUTORIALS.keys():
        tutorialOptionButton.add_item(tutorial)

func SetMapTexture(texture: Texture2D) -> void :
    mapTexture.texture = texture
    mapTexture.scale = Vector2.ONE * 600.0 / texture.get_height() * 0.45

func FindOptionButtonId(optionButton: OptionButton, key: String) -> int:
    for index in optionButton.item_count:
        if optionButton.get_item_text(index) == key:
            return optionButton.get_item_id(index)
    return -1

func LevelNumberSpinBoxValueChanged(value: float) -> void :
    levelConfig.levelNumber = int(value)

func LevelNameLineEditTextChanged(newText: String) -> void :
    levelConfig.levelName = newText

func LevelDescriptionLineEditTextChanged() -> void :
    levelConfig.description = levelDescriptionTextEdit.text

func HomeWorldOptionButtonItemSelected(index: int) -> void :
    var homeWorldName: String = homeWorldOptionButton.get_item_text(index)
    levelConfig.homeWorld = homeWorldDictionary[homeWorldName]

func MapOptionButtonItemSelected(index: int) -> void :
    if !isInit:
        levelConfig.canExport = false
    var mapName: String = mapOptionButton.get_item_text(index)
    var mapConfig: TowerDefenseMapConfig = ResourceManager.MAPS[mapDictionary[mapName]]
    TowerDefenseMapControl.instance.Init(mapConfig)
    LevelEditorWaveEditor.instance.MapChange(mapConfig)
    SetMapTexture(mapConfig.mapTexture)
    levelConfig.map = mapDictionary[mapName]

func BgmOptionButtonItemSelected(index: int) -> void :
    var bgmName: String = bgmOptionButton.get_item_text(index)
    levelConfig.backgroundMusic = bgmDictionary[bgmName]

func TalkOptionButtonItemSelected(index: int) -> void :
    var talkName: String = talkOptionButton.get_item_text(index)
    levelConfig.talk = talkName

func TutorialOptionButtonItemSelected(index: int) -> void :
    var tutorialName: String = tutorialOptionButton.get_item_text(index)
    levelConfig.tutorial = tutorialName

func TalkCheckBoxToggled(toggledOn: bool) -> void :
    talkOptionButton.disabled = toggledOn
    levelConfig.isCustomTalk = toggledOn
    if toggledOn:
        talkOptionButton.selected = -1
        levelConfig.talk = ""

func TutorialCheckBoxToggled(toggledOn: bool) -> void :
    tutorialOptionButton.disabled = toggledOn
    tutorialOptionButton.selected = -1
    if toggledOn:
        levelConfig.isCustomTutorial = toggledOn
        levelConfig.tutorial = ""

func MowerUseCheckBoxToggled(toggledOn: bool) -> void :
    if !isInit:
        levelConfig.canExport = false
    levelConfig.mowerUse = toggledOn
