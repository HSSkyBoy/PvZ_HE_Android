class_name ShopItem extends Control

@onready var costLabel: Label = %CostLabel
@onready var describeLabel: Label = %DescribeLabel
@onready var soldOutLabel: Label = %SoldOutLabel
@onready var itemButton: SpriteBrightButton = %ItemButton
@onready var packetNode: Control = %PacketNode

signal pressed(item: ShopItem)
signal talk(text: String)

var config: ShopItemConfig
var currentStageId: int = -1

var cost: int = 0:
    set(_cost):
        cost = _cost
        costLabel.text = "$ %d" % cost

func Init(_config) -> void :
    config = _config
    Refresh()

func Refresh() -> void :
    soldOutLabel.visible = false
    describeLabel.visible = true
    itemButton.disabled = false
    for stageId in config.stageList.size():
        var stage: ShopItemStageConfig = config.stageList[stageId]
        match stage.saveType:
            "Feature":
                var featureData: int = GameSaveManager.GetFeatureValue(stage.saveKey)
                if featureData >= stage.openMinNum && featureData < stage.openMaxNum:
                    cost = stage.cost
                    itemButton.texture = stage.texture
                    describeLabel.text = stage.describe
                    currentStageId = stageId
                    return
            "TowerDefensePacket":
                itemButton.modulate.a = 0.0
                var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(stage.saveKey)
                var packet: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()
                packet.setPcLayout = true
                packetNode.add_child(packet)
                packet.Init(packetConfig)
                if !packetConfig.Unlock():
                    cost = stage.cost
                    describeLabel.text = stage.describe
                    currentStageId = stageId
                    return
    itemButton.texture = config.stageList[config.stageList.size() - 1].texture
    describeLabel.text = config.stageList[config.stageList.size() - 1].describe
    cost = config.stageList[config.stageList.size() - 1].cost
    soldOutLabel.visible = true
    describeLabel.visible = false
    itemButton.disabled = true

func Sale() -> void :
    var stage: ShopItemStageConfig = config.stageList[currentStageId]
    match stage.saveType:
        "Feature":
            var featureData: int = GameSaveManager.GetFeatureValue(stage.saveKey)
            GameSaveManager.SetFeatureValue(stage.saveKey, featureData + stage.addNum)
        "TowerDefensePacket":
            var packetData: Dictionary = GameSaveManager.GetTowerDefensePacketValue(stage.saveKey)
            packetData["Unlock"] = true
            GameSaveManager.SetTowerDefensePacketValue(stage.saveKey, packetData)
    GameSaveManager.Save()
    Refresh()

func Pressed() -> void :
    pressed.emit(self)

func Talk() -> void :
    talk.emit(config.stageList[currentStageId].npcTalk)
