extends Control

@onready var spriteNode: Control = %SpriteNode
@onready var accessLabel: Label = %AccessLabel
@onready var getButton: NinePatchButtonBase = %GetButton

var data: Dictionary
var finish: int = 0

func Init(_data: Dictionary, _finish: int) -> void :
    data = _data
    finish = _finish
    var config = TowerDefenseManager.GetPacketConfig(data["ShowCharacter"]).characterConfig
    var sprite = TowerDefenseManager.GetCharacterSprite(data["ShowCharacter"])
    config.customData.SetCustomFliters(sprite, data["ShowCustom"])
    spriteNode.add_child(sprite)

    accessLabel.text = "累计完成%d天挑战获得" % data["ConditionArg"][0]

    if data["ConditionArg"][0] > finish:
        getButton.disable = true
        getButton.text = "无法领取"
    else:
        if GameSaveManager.GetFeatureValue(data["Key"]):
            getButton.disable = true
            getButton.text = "已领取"

func GetButtonPressed() -> void :
    GameSaveManager.SetFeatureValue(data["Key"], true)
    GameSaveManager.Save()
    getButton.disable = true
    getButton.text = "已领取"
