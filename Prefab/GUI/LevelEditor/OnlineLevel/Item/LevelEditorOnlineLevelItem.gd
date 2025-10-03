extends Control

const PATH: String = "user://OnlineLevel"

@onready var nameLabel: Label = %NameLabel
@onready var mapTexture: TextureRect = %MapTexture
@onready var finishTexture: TextureRect = %FinishTexture

signal select(_url: String, _id: String)

var id: String

func Init(data: Dictionary) -> void :
    id = data.get("id", "-1")
    nameLabel.text = data.get("name", "")
    var mapConfig: TowerDefenseMapConfig = TowerDefenseManager.GetMapConfig(data.get("map", "Frontlawn"))
    mapTexture.texture = mapConfig.mapTexture
    var _levelName: String = "OnlineLevel-%s" % id
    var _levelData: Dictionary = GameSaveManager.GetLevelValue(_levelName)
    if _levelData.get_or_add("Key", {}).get_or_add("Finish", 0) > 0:
        finishTexture.visible = true

func SelectButtonPressed() -> void :
    var dialog = DialogManager.DialogCreate("OnlineLevelPreview")
    dialog.InitDialog(id)
    dialog.select.connect(EmitSelect)

func EmitSelect(url: String) -> void :
    select.emit(url, id)
