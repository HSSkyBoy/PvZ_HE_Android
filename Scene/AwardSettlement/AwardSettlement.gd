extends Node

const LEVEL_RESOURCE = preload("res://Asset/Config/Level/LevelResource.json")

@onready var awardSettlementBackground: TextureRect = %AwardSettlementBackground

@onready var awardShowNode: Control = %AwardShowNode
@onready var imageShowNode: Control = %ImageShowNode

@onready var typeLabel: Label = %TypeLabel
@onready var nameLabel: Label = %NameLabel
@onready var describeLabel: Label = %DescribeLabel
@onready var marker: Control = %Marker

@onready var imageSprite: Sprite2D = %ImageSprite

@onready var menuButton: NinePatchButtonBase = %MenuButton
@onready var nextLevelButton: NinePatchButtonBase = %NextLevelButton
@onready var moreBackButton: TextureButton = $MoreBackButton

func _ready() -> void :


    AudioManager.AudioPlay("ZenGarden", AudioManagerEnum.TYPE.MUSIC)

    match Global.currentAwardType:
        TowerDefenseEnum.LEVEL_REWARDTYPE.PACKET:
            InitPacket(Global.currentAwardValue)
        TowerDefenseEnum.LEVEL_REWARDTYPE.COLLECTABLE:
            InitCollectable(Global.currentAwardValue)

    if TowerDefenseManager.SetNextLevel(Global.currentLevelChoose, Global.currentChapterId, Global.currentLevelId):
        nextLevelButton.visible = true
        menuButton.visible = false

func InitPacket(packetName: String) -> void :
    var config: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetName)
    if config.characterConfig is TowerDefensePlantConfig:
        typeLabel.text = "AWARD_PACKET_PLANT"

    var packet: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()
    marker.add_child(packet)
    packet.Init(config)
    packet.onlyDraw = true
    packet.scale = 1.25 * Vector2.ONE

    nameLabel.text = config.name
    describeLabel.text = config.describe

func InitCollectable(collectableName: String) -> void :
    var collectableConfig: CollectableConfig = TowerDefenseManager.GetCollectable(collectableName)
    if collectableConfig.config is ShovelConfig:
        typeLabel.text = "AWARD_COLLECTABLE_SHOVEL"
        var sprite: Sprite2D = Sprite2D.new()
        sprite.texture = collectableConfig.config.texture
        sprite.scale = Vector2.ONE * 80.0 / sprite.texture.get_width()
        marker.add_child(sprite)
        nameLabel.text = collectableConfig.config.name
        describeLabel.text = collectableConfig.config.describe
    if collectableConfig.config is AwardSettlementConfig:
        awardShowNode.visible = false
        imageShowNode.visible = true
        awardSettlementBackground.texture = collectableConfig.config.background
        imageSprite.texture = collectableConfig.config.image
        menuButton.position.y = 520.0
        nextLevelButton.position.y = 520.0

func MenuButtonPressed() -> void :
    Global.currentAwardMode = true
    match Global.enterLevelMode:
        "LevelChoose":
            SceneManager.ChangeScene("LevelChoose")
        "DailyLevel":
            SceneManager.ChangeScene("MainMenu")
        "DiyLevel":
            SceneManager.ChangeScene("LevelEditorStage")
        "LoadLevel":
            SceneManager.ChangeScene("LevelEditorStage")
        "OnlineLevel":
            SceneManager.ChangeScene("LevelEditorStage")

func NextLevelButtonPressed() -> void :
    SceneManager.ChangeScene("TowerDefense")
