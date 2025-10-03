class_name LevelEditorMapEditor extends Control

static  var instance: LevelEditorMapEditor

@onready var characterNode: Node2D = %CharacterNode
@onready var shovelButton: TextureButton = %ShovelButton

@export var levelConfig: TowerDefenseLevelConfig

var mapControl: TowerDefenseMapControl

var shovelShow: bool = false

func Init(_levelConfig: TowerDefenseLevelConfig) -> void :
    levelConfig = _levelConfig

func Save(isSave: bool = false) -> void :
    Release()
    if !is_instance_valid(levelConfig):
        return
    if (isSave && is_visible_in_tree()) || ( !isSave && !is_visible_in_tree()):
        levelConfig.preSpawnList.clear()
        var characterSaveList: Array[TowerDefenseCharacter] = []
        for x in range(1, mapControl.config.gridNum.x + 1):
            for y in range(1, mapControl.config.gridNum.y + 1):
                var cell: TowerDefenseCellInstance = mapControl.plantGrid[x][y]
                var characterList = cell.GetCharacterListSave()
                for character: TowerDefenseCharacter in characterList:
                    var preSpawnConfig: TowerDefenseLevelPreSpawnConfig = TowerDefenseLevelPreSpawnConfig.new()
                    preSpawnConfig.gridPos = Vector2(x, y)
                    preSpawnConfig.packetName = character.packet.saveKey
                    levelConfig.preSpawnList.append(preSpawnConfig)
                    characterSaveList.append(character)
        for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
            if characterSaveList.has(character):
                continue
            var preSpawnConfig: TowerDefenseLevelPreSpawnConfig = TowerDefenseLevelPreSpawnConfig.new()
            preSpawnConfig.gridPos = character.gridPos
            preSpawnConfig.packetName = character.packet.saveKey
            levelConfig.preSpawnList.append(preSpawnConfig)
            characterSaveList.append(character)
        if ( !isSave && !is_visible_in_tree()):
            ClearCharacter()
    elif is_visible_in_tree():
        for preSpawn: TowerDefenseLevelPreSpawnConfig in levelConfig.preSpawnList:
            preSpawn.Spawn()

func Clear() -> void :
    levelConfig = null
    ClearCharacter()

func ClearCharacter() -> void :
    for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
        character.queue_free()

func _ready() -> void :
    instance = self
    mapControl = TowerDefenseMapControl.instance

func ShovelButtonPressed() -> void :
    if !mapControl:
        return
    if is_instance_valid(mapControl.packetPick):
        mapControl.packetPick.Reset()
        mapControl.packetPick = null
        if mapControl.followSprite:
            mapControl.followSprite.queue_free()
            mapControl.followSprite = null
        if mapControl.plantSprite:
            mapControl.plantSprite.queue_free()
            mapControl.plantSprite = null
    if shovelButton.button_pressed:
        AudioManager.AudioPlay("Shovel", AudioManagerEnum.TYPE.SFX)
        mapControl.shovelPick = true
        mapControl.shovelSprite.position = Vector2(-100, -100)
        mapControl.shovelSprite.visible = true
    else:
        AudioManager.AudioPlay("ShovelDeny", AudioManagerEnum.TYPE.SFX)
        mapControl.shovelPick = false
        mapControl.shovelSprite.visible = false

func Release() -> void :
    if !mapControl:
        return
    if mapControl.shovelPick:
        AudioManager.AudioPlay("ShovelDeny", AudioManagerEnum.TYPE.SFX)
    if is_instance_valid(mapControl.packetPick):
        if !mapControl.packetPick.config.characterConfig.plantCover.is_empty():
            for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
                if mapControl.packetPick.config.characterConfig.plantCover.has(character.config.name):
                    character.SetSpriteGroupShaderParameter("cover", false)
        mapControl.packetPick.Reset()
        mapControl.packetPick = null
    mapControl.shovelPick = false
    mapControl.shovelSprite.visible = false
    mapControl.plantfoodPick = false
    mapControl.plantfoodSprite.visible = false
    shovelButton.button_pressed = false
    if mapControl.followSprite:
        mapControl.followSprite.queue_free()
        mapControl.followSprite = null
    if mapControl.plantSprite:
        mapControl.plantSprite.queue_free()
        mapControl.plantSprite = null
