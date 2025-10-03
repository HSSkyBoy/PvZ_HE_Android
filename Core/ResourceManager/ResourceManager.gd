extends Node2D

const EFFECT_DIRT_NAME: Dictionary = {
    GeneralEnum.HOMEWORLD.MORDEN: "DirtSpawnGrass"
}

const LEVEL_RESOURCE = preload("res://Asset/Config/Level/LevelResource.json")
@export var LEVELS: Dictionary = {}

const MAP_RESOURCE = preload("res://Asset/Config/Map/MapResource.json")
@export var MAPS: Dictionary = {}

const BGM_RESOURCE = preload("res://Asset/Config/BGM/BGMResource.json")
@export var BGMS: Dictionary = {}

const PROJECTILE_RESOURCE = preload("res://Asset/Config/Projectile/ProjectileResource.json")
@export var PROJECTILE_CONFIG: Dictionary = {}

const AUDIO_RESOURCE = preload("res://Asset/Config/Audio/AudioResource.json")
@export var AUDIOS: Dictionary = {}

const CHARACTER_RESOURCE: JSON = preload("res://Asset/Config/Character/CharacterResource.json")
@export var CHARCTAER_SPRITE: Dictionary = {}
@export var TOWERDEFENSE_CHARCATERS: Dictionary = {}
@export var TOWERDEFENSE_PACKETS: Dictionary = {}

const TALK_RESOURCE = preload("res://Asset/Config/Npc/TalkResource.json")
@export var TALKS: Dictionary = {}

const TUTORIAL_RESOURCE = preload("res://Asset/Config/Tutorial/TutorialResource.json")
@export var TUTORIALS: Dictionary = {}

const PACKET_BANK_RESOURCE = preload("res://Asset/Config/PacketBank/PacketBankResource.json")
@export var TOWERDEFENSE_PACKETBANKS: Dictionary = {}

const COLLECTABLE_RESOURCE = preload("res://Asset/Config/Collectable/CollectableResource.json")
@export var COLLECTABLES: Dictionary = {}

const SHOVEL_RESOURCE = preload("res://Asset/Config/Shovel/ShovelResource.json")
@export var SHOVELS: Dictionary = {}

const MOWER_RESOURCE = preload("res://Asset/Config/Mower/MowerResource.json")
@export var MOWERS: Dictionary = {}

const SHOP_RESOURCE = preload("res://Asset/Config/Shop/ShopResource.json")
@export var SHOPS: Dictionary = {}

@export var DAILY_LEVEL_DATA: Dictionary = {}

const DAILY_LEVEL_AWARD = preload("res://Asset/Config/DailyChallenge/DailyChallengeAward.json")

signal loadOver()
signal loadPercentage(persontage: float, _stepName: String)

var thread: Thread = Thread.new()

var stepMax: int = 13
var stepName: String = "LoadMap"
var currentStep: int = 0

func _ready() -> void :


    thread.start(Load)

func Load() -> void :
    currentStep = 0
    stepName = "LOAD_MAP"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for mapName: String in MAP_RESOURCE.data.keys():
        MAPS[mapName] = load(MAP_RESOURCE.data[mapName])

    currentStep = 1
    stepName = "LOAD_BGM"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for BGMName: String in BGM_RESOURCE.data.keys():
        BGMS[BGMName] = load(BGM_RESOURCE.data[BGMName])

    currentStep = 2
    stepName = "LOAD_PROJECTILE"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for ProjectileName: String in PROJECTILE_RESOURCE.data.keys():
        PROJECTILE_CONFIG[ProjectileName] = load(PROJECTILE_RESOURCE.data[ProjectileName])

    currentStep = 3
    stepName = "LOAD_AUDIO"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for audioName: String in AUDIO_RESOURCE.data.keys():
        AUDIOS[audioName] = load(AUDIO_RESOURCE.data[audioName])

    currentStep = 4
    stepName = "LOAD_CHARACTER"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for characterName: String in CHARACTER_RESOURCE.data.keys():
        var characterData: Dictionary = CHARACTER_RESOURCE.data.get(characterName, {}) as Dictionary
        if !characterData.is_empty():
            CHARCTAER_SPRITE[characterName] = load(characterData.get("Sprite"))
            TOWERDEFENSE_CHARCATERS[characterName] = load(characterData.get("Scene"))
            var characterPacketData: Dictionary = characterData.get("Packet", {}) as Dictionary
            for packetName: String in characterPacketData.keys():
                TOWERDEFENSE_PACKETS[packetName] = load(characterPacketData.get(packetName))

    currentStep = 5
    stepName = "LOAD_TALK"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for talkName: String in TALK_RESOURCE.data.keys():
        TALKS[talkName] = load(TALK_RESOURCE.data[talkName])

    currentStep = 6
    stepName = "LOAD_TUTORIAL"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for tutorialName: String in TUTORIAL_RESOURCE.data.keys():
        TUTORIALS[tutorialName] = load(TUTORIAL_RESOURCE.data[tutorialName])

    currentStep = 7
    stepName = "LOAD_PACKETBANK"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for packetBankName: String in PACKET_BANK_RESOURCE.data.keys():
        var config: TowerDefensePacketBankData = TowerDefensePacketBankData.new()
        var packetBankData: Dictionary = PACKET_BANK_RESOURCE.data[packetBankName]
        var category: Dictionary = packetBankData["Category"]
        config.category = category.duplicate(true)
        TOWERDEFENSE_PACKETBANKS[packetBankName] = config

    for packetBankName: String in PACKET_BANK_RESOURCE.data.keys():
        var packetBankData: Dictionary = PACKET_BANK_RESOURCE.data[packetBankName]
        var include: Array = packetBankData["Include"]
        var config: TowerDefensePacketBankData = TOWERDEFENSE_PACKETBANKS[packetBankName]
        for includeName: String in include:
            var includeConfig: TowerDefensePacketBankData = TOWERDEFENSE_PACKETBANKS[includeName]
            for categoryName: String in includeConfig.category.keys():
                if config.category.has(categoryName):
                    config.category[categoryName].append_array(includeConfig.category[categoryName])
                else:
                    config.category[categoryName] = includeConfig.category[categoryName].duplicate(true)

    currentStep = 8
    stepName = "LOAD_COLLECTABLE"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for collectableName: String in COLLECTABLE_RESOURCE.data.keys():
        COLLECTABLES[collectableName] = load(COLLECTABLE_RESOURCE.data[collectableName])

    currentStep = 9
    stepName = "LOAD_SHOVEL"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for shovelName: String in SHOVEL_RESOURCE.data.keys():
        SHOVELS[shovelName] = load(SHOVEL_RESOURCE.data[shovelName])

    currentStep = 10
    stepName = "LOAD_MOWER"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for mowerName: String in MOWER_RESOURCE.data.keys():
        MOWERS[mowerName] = load(MOWER_RESOURCE.data[mowerName])

    currentStep = 11
    stepName = "LOAD_SHOP"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    for shopName: String in SHOP_RESOURCE.data.keys():
        SHOPS[shopName] = load(SHOP_RESOURCE.data[shopName])

    currentStep = 12
    stepName = "LOAD_LEVEL"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    LEVELS = LEVEL_RESOURCE.data.duplicate(true)

    currentStep = 13
    stepName = "LOAD_MOD"
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)

    ModManager.Find()

    currentStep = 14
    stepName = ""
    loadPercentage.emit.call_deferred(float(currentStep) / float(stepMax), stepName)
    loadOver.emit.call_deferred()
