class_name InformationPanel extends Control

const ALMANAC_GROUND_DAY = preload("uid://ceqaimccnt56q")
const ALMANAC_GROUND_NIGHT = preload("uid://wjso8qh4jnie")
const ALMANAC_GROUND_NIGHT_POOL = preload("uid://y166oxgfiohu")
const ALMANAC_GROUND_POOL = preload("uid://cpfhqdus53fr0")

@onready var tabTexture: TextureRect = %TabTexture
@onready var groundTexture: TextureRect = %GroundTexture
@onready var informationNode: Control = %InformationNode
@onready var customNode: Control = %CustomNode

@onready var spriteNode: Control = %SpriteNode

@onready var nameLabel: Label = %NameLabel
@onready var expressionLabel: RichTextLabel = %ExpressionLabel
@onready var handbookExpressionLabel: RichTextLabel = %HandbookExpressionLabel
@onready var handbookStoryLabel: RichTextLabel = %HandbookStoryLabel
@onready var informationCostLabel: RichTextLabel = %InformationCostLabel
@onready var informationColdDownLabel: RichTextLabel = %InformationColdDownLabel
@onready var scrollContainer: ScrollContainer = %ScrollContainer

@onready var informationTabButton: TextureButton = %InformationTabButton
@onready var informationTabLabel: Label = %InformationTabLabel
@onready var customTabButton: TextureButton = %CustomTabButton
@onready var customTabLabel: Label = %CustomTabLabel

@onready var preCustomButton: SpriteBrightButton = %PreCustomButton
@onready var equipmentButton: NinePatchButtonBase = %EquipmentButton
@onready var nextCustomButton: SpriteBrightButton = %NextCustomButton
@onready var nooneCustomLabel: Label = %NooneCustomLabel

@onready var customNameLabel: RichTextLabel = %CustomNameLabel
@onready var customAccessLabel: RichTextLabel = %CustomAccessLabel
@onready var customStoryLabel: RichTextLabel = %CustomStoryLabel

var currentCharcter: TowerDefenseCharacter
var currentSpriteImage: Sprite2D

var currentPacketConfig: TowerDefensePacketConfig = null
var currentCustom: String = ""
var currentCustomId: int = 0:
    set(_currentCustomId):
        currentCustomId = _currentCustomId
        FreshCustom()

func InitPacket(packetConfig: TowerDefensePacketConfig) -> void :
    Clear()
    currentPacketConfig = packetConfig
    var characterConfig: TowerDefenseCharacterConfig = packetConfig.characterConfig
    FreshBackground(characterConfig.plantGridType.has(TowerDefenseEnum.PLANTGRIDTYPE.WATER), characterConfig.sleepTime == "Day")

    currentCharcter = TowerDefenseManager.GetChacraterScene(characterConfig.name).instantiate()
    currentCharcter.inGame = false
    currentCharcter.packet = packetConfig
    spriteNode.add_child(currentCharcter)
    currentCharcter.sprite.light_mask = 0
    currentCharcter.sprite.process_mode = Node.PROCESS_MODE_ALWAYS
    currentCharcter.state.process_mode = Node.PROCESS_MODE_DISABLED
    for component in currentCharcter.get_children(true):
        if component is ComponentBase:
            component.process_mode = Node.PROCESS_MODE_DISABLED
    currentCharcter.sprite.SetAnimation(packetConfig.packetAnimeClip, true)

    if characterConfig.armorData:
        if packetConfig.initArmor.size() > 0:
            for armorName: String in packetConfig.initArmor:
                var armor: CharacterArmorConfig = characterConfig.armorData.armorDictionary[armorName]
                match armor.replaceMethod:
                    "Media":
                        characterConfig.armorData.OpenArmorFliters(currentCharcter.sprite, armorName)
                        characterConfig.armorData.SetArmorReplace(currentCharcter.sprite, armorName, 0)
                    "Sprite":
                        var slotNode: AdobeAnimateSlot = currentCharcter.sprite.get_node(armor.replaceSpriteSlotPath)
                        var _sprite: Sprite2D = Sprite2D.new()
                        _sprite.texture = armor.stageAnimeTexture[0]
                        _sprite.position = armor.replaceSpriteOffset
                        _sprite.rotation = armor.replaceSpriteRotation
                        _sprite.scale = armor.replaceSpriteScale
                        slotNode.add_child(_sprite)

    scrollContainer.scroll_vertical = 0

    nameLabel.text = packetConfig.name
    expressionLabel.visible = packetConfig.describe != ""
    expressionLabel.text = "[color=2f375e]%s[/color]" % tr(packetConfig.describe)
    handbookExpressionLabel.visible = packetConfig.handbookDescribe != ""
    handbookExpressionLabel.text = packetConfig.handbookDescribe
    handbookStoryLabel.visible = packetConfig.handbookStory != ""
    handbookStoryLabel.text = packetConfig.handbookStory
    informationCostLabel.text = "[color=ab5e57]花费:%d[/color]" % characterConfig.cost
    informationColdDownLabel.text = "[color=ab5e57]冷却时间:%.1f[/color]" % characterConfig.packetCooldown

    informationTabButton.button_pressed = true
    informationTabButton.pressed.emit()

func InitShovel(shovelConfig: ShovelConfig) -> void :
    Clear()
    FreshBackground()
    tabTexture.visible = false
    informationTabButton.visible = false
    customTabButton.visible = false
    currentSpriteImage = Sprite2D.new()
    currentSpriteImage.texture = shovelConfig.texture
    spriteNode.add_child(currentSpriteImage)

    nameLabel.text = shovelConfig.name
    expressionLabel.visible = shovelConfig.describe != ""
    expressionLabel.text = "[color=2f375e]%s[/color]" % tr(shovelConfig.describe)
    handbookExpressionLabel.visible = shovelConfig.handbookDescribe != ""
    handbookExpressionLabel.text = shovelConfig.handbookDescribe
    handbookStoryLabel.visible = shovelConfig.handbookStory != ""
    handbookStoryLabel.text = shovelConfig.handbookStory
    informationCostLabel.text = ""
    informationColdDownLabel.text = ""

func InitMower(mowerConfig: MowerConfig) -> void :
    Clear()
    FreshBackground()
    tabTexture.visible = false
    informationTabButton.visible = false
    customTabButton.visible = false
    currentSpriteImage = Sprite2D.new()
    currentSpriteImage.texture = mowerConfig.texture
    currentSpriteImage.scale = Vector2.ONE * 0.6
    spriteNode.add_child(currentSpriteImage)

    nameLabel.text = mowerConfig.name
    expressionLabel.visible = mowerConfig.describe != ""
    expressionLabel.text = "[color=2f375e]%s[/color]" % tr(mowerConfig.describe)
    handbookExpressionLabel.visible = mowerConfig.handbookDescribe != ""
    handbookExpressionLabel.text = mowerConfig.handbookDescribe
    handbookStoryLabel.visible = mowerConfig.handbookStory != ""
    handbookStoryLabel.text = mowerConfig.handbookStory
    informationCostLabel.text = ""
    informationColdDownLabel.text = ""

func EnterInformation() -> void :
    var characterConfig: TowerDefenseCharacterConfig = currentPacketConfig.characterConfig
    if characterConfig.customData:
        var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(currentPacketConfig.saveKey)
        if packetValue.get_or_add("Key", {}).get_or_add("Custom", "") != "":
            currentCharcter.currentCustom = [packetValue["Key"]["Custom"]]
        else:
            currentCharcter.currentCustom = []

func EnterCustom() -> void :
    var characterConfig: TowerDefenseCharacterConfig = currentPacketConfig.characterConfig
    if characterConfig.customData:
        var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(currentPacketConfig.saveKey)
        if packetValue.get_or_add("Key", {}).get_or_add("Custom", "") != "":
            for customId in characterConfig.customData.customList.size():
                if characterConfig.customData.customList[customId].customName == packetValue["Key"]["Custom"]:
                    currentCustomId = customId
                    break
        else:
            currentCustomId = 0
    else:
        nooneCustomLabel.visible = true
        await get_tree().physics_frame
        customNode.visible = false

func Clear() -> void :
    if is_instance_valid(currentSpriteImage):
        currentSpriteImage.queue_free()
    if is_instance_valid(currentCharcter):
        currentCharcter.queue_free()

func TabButtonPresed() -> void :
    nooneCustomLabel.visible = false
    informationNode.visible = false
    customNode.visible = false
    if informationTabButton.button_pressed:
        EnterInformation()
        informationNode.visible = true
        informationTabLabel.add_theme_color_override("font_color", Color.YELLOW)
    else:
        informationTabLabel.add_theme_color_override("font_color", Color("c35b25"))
    if customTabButton.button_pressed:
        EnterCustom()
        customNode.visible = true
        customTabLabel.add_theme_color_override("font_color", Color.YELLOW)
    else:
        customTabLabel.add_theme_color_override("font_color", Color("c35b25"))

func EquipmentButtonPressed() -> void :
    match equipmentButton.text:
        "装备装扮":
            var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(currentPacketConfig.saveKey)
            if !packetValue.has("Key"):
                packetValue["Key"] = {}
            packetValue["Key"]["Custom"] = currentCustom
            GameSaveManager.SetTowerDefensePacketValue(currentPacketConfig.saveKey, packetValue)
            equipmentButton.text = "卸下装扮"
        "卸下装扮":
            var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(currentPacketConfig.saveKey)
            if !packetValue.has("Key"):
                packetValue["Key"] = {}
            packetValue["Key"]["Custom"] = ""
            GameSaveManager.SetTowerDefensePacketValue(currentPacketConfig.saveKey, packetValue)
            equipmentButton.text = "装备装扮"

func FreshBackground(isWater: bool = false, isNight: bool = false) -> void :
    if !isWater:
        if !isNight:
            groundTexture.texture = ALMANAC_GROUND_DAY
        else:
            groundTexture.texture = ALMANAC_GROUND_NIGHT
    else:
        if !isNight:
            groundTexture.texture = ALMANAC_GROUND_POOL
        else:
            groundTexture.texture = ALMANAC_GROUND_NIGHT_POOL

func FreshCustom() -> void :
    var characterConfig: TowerDefenseCharacterConfig = currentPacketConfig.characterConfig
    var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(currentPacketConfig.saveKey)
    currentCustom = characterConfig.customData.customList[currentCustomId].customName
    currentCharcter.currentCustom = [currentCustom]

    if Global.debugOpenAllCustom || characterConfig.customData.customList[currentCustomId].openKey == "" || GameSaveManager.GetFeatureValue(characterConfig.customData.customList[currentCustomId].openKey):
        equipmentButton.disable = false
        if packetValue.get_or_add("Key", {}).get_or_add("Custom", "") == currentCustom:
            equipmentButton.text = "卸下装扮"
        else:
            equipmentButton.text = "装备装扮"
    else:
        equipmentButton.disable = true
        equipmentButton.text = "未获得"

    customNameLabel.text = "[color=ff3eff]%s[/color]" % tr(characterConfig.customData.customList[currentCustomId].customHandbookName)
    customAccessLabel.text = "[color=red]获取方式[/color]:%s" % tr(characterConfig.customData.customList[currentCustomId].customHandbookAccess)
    customStoryLabel.text = characterConfig.customData.customList[currentCustomId].customHandbookStory

func PreCustomButtonPressed() -> void :
    var characterConfig: TowerDefenseCharacterConfig = currentPacketConfig.characterConfig
    currentCustomId = (currentCustomId - 1 + characterConfig.customData.customList.size()) %characterConfig.customData.customList.size()

func NextCustomButtonPressed() -> void :
    var characterConfig: TowerDefenseCharacterConfig = currentPacketConfig.characterConfig
    currentCustomId = (currentCustomId + 1 + characterConfig.customData.customList.size()) %characterConfig.customData.customList.size()
