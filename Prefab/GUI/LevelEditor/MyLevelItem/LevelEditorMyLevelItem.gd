extends Control

const PATH: String = "user://Diy"

@onready var nameLabel: Label = %NameLabel
@onready var mapTexture: TextureRect = %MapTexture

signal select(_uid: String)
signal delete(_uid: String)

var uid: String

var levelConfig: TowerDefenseLevelConfig

func Init(_uid: String) -> void :
    uid = _uid
    var filePath: String = PATH + "/" + uid + ".tres"
    var res = load(filePath)
    if res is TowerDefenseLevelConfig:
        levelConfig = res
        nameLabel.text = levelConfig.levelName
        var mapConfig: TowerDefenseMapConfig = TowerDefenseManager.GetMapConfig(levelConfig.map)
        mapTexture.texture = mapConfig.mapTexture

func DeleteButtonPressed() -> void :
    var dialog = DialogManager.DialogCreate("MyLevelDelete")
    dialog.pressDelete.connect(
        func():
            delete.emit(uid)
            queue_free()
    )

func SelectButtonPressed() -> void :
    select.emit(uid)
