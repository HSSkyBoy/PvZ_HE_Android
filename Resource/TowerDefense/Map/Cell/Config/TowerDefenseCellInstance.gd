class_name TowerDefenseCellInstance extends Resource

const DIRT = preload("res://Prefab/Particles/Dirt/Dirt/Dirt.tscn")
const SURROUND_UNCLUDE_GRID: Array[TowerDefenseEnum.PLANTGRIDTYPE] = [TowerDefenseEnum.PLANTGRIDTYPE.SOIL, TowerDefenseEnum.PLANTGRIDTYPE.BRICK, TowerDefenseEnum.PLANTGRIDTYPE.WATER]

@export var gridType: Array[TowerDefenseEnum.PLANTGRIDTYPE] = [TowerDefenseEnum.PLANTGRIDTYPE.GROUND, TowerDefenseEnum.PLANTGRIDTYPE.AIR]
@export var elementFlags: int = 0
@export var isWater: bool = false
var characterList: Array[TowerDefenseCharacter]
var characterSlotDictionary: Dictionary = {}
var slot: Dictionary[TowerDefenseEnum.PLANTGRIDTYPE, TowerDefenseCharacter] = {}
var characterSurround: TowerDefenseCharacter
var characterLadder: TowerDefenseCharacter
var gridPos: Vector2i = Vector2i.ZERO
var groundHeightCurve: CurveTexture

func Init(config: TowerDefenseCellConfig) -> void :
    gridType = config.gridType.duplicate(true)
    elementFlags = config.elementFlags
    characterList.clear()
    characterSlotDictionary.clear()
    slot.clear()
    groundHeightCurve = config.groundHeightCurve
    for type: TowerDefenseEnum.PLANTGRIDTYPE in gridType:
        slot[type] = null

func Clear() -> void :
    for character: TowerDefenseCharacter in characterList:
        if is_instance_valid(character):
            character.Destroy()
    characterList.clear()
    characterSlotDictionary.clear()
    if is_instance_valid(characterSurround):
        characterSurround.Destroy()
    if is_instance_valid(characterLadder):
        characterLadder.Destroy()
    ClearEmpty()

func ClearEmpty() -> void :
    for x in characterList.size():
        for i in characterList.size():
            if !is_instance_valid(characterList[i]):
                characterList.remove_at(i)
                break
    for x in characterSlotDictionary.size():
        for key in characterSlotDictionary.keys():
            if !is_instance_valid(key):
                characterSlotDictionary.erase(key)
                break
    if !is_instance_valid(characterSurround):
        characterSurround = null
    if !is_instance_valid(characterLadder):
        characterLadder = null

func CharacterPlant(packetConfig: TowerDefensePacketConfig, character: TowerDefenseCharacter, noLimit: bool = false) -> void :
    ClearEmpty()
    var nutBandaging: bool = GameSaveManager.GetFeatureValue("NutBandaging") > 0
    var potReplacement: bool = GameSaveManager.GetFeatureValue("PotReplacement") > 0
    var characterConfig: TowerDefenseCharacterConfig = packetConfig.characterConfig
    if characterConfig is TowerDefenseItemConfig:
        if characterConfig.isLadder:
            if HasWallnut():
                characterLadder = character
                characterList.append(character)
                characterSlotDictionary[character] = null
                character.destroy.connect(CharacterDestroy)
                return

    if !packetConfig.GetPlantCover().is_empty():
        if !noLimit:
            for _character: TowerDefenseCharacter in characterList:
                if !is_instance_valid(_character):
                    continue
                if packetConfig.GetPlantCover().has(_character.config.name):
                    if !Global.isEditor || SceneManager.currentScene != "LevelEditorStage":
                        var findId = packetConfig.GetPlantCover().find(_character.config.name)
                        if characterConfig.plantCoverRecycle.size() > findId:
                            character.SunCreate(character.global_position, characterConfig.plantCoverRecycle[findId], TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
                    CharacterReplace(_character, character)
                    return

    if characterConfig.plantGridType.has(TowerDefenseEnum.PLANTGRIDTYPE.SURROUND):
        if !is_instance_valid(characterSurround):
            characterSurround = character
            characterList.append(character)
            characterSlotDictionary[character] = null
            character.destroy.connect(CharacterDestroy)
            return

    if nutBandaging && characterConfig.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.NUT:
        for _character: TowerDefenseCharacter in characterList:
            if !is_instance_valid(_character):
                continue
            if characterConfig.name != _character.config.name:
                continue
            if !_character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.NUT:
                continue
            if _character.instance.damagePointIndex <= 1:
                continue
            CharacterReplace(_character, character)
            return

    if potReplacement:
        if characterConfig.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.POT:
            for _character: TowerDefenseCharacter in characterList:
                if !is_instance_valid(_character):
                    continue
                if characterConfig.name == _character.config.name:
                    continue
                if !_character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.POT:
                    continue
                CharacterReplace(_character, character)
                return
        if characterConfig.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.LILYPAD:
            for _character: TowerDefenseCharacter in characterList:
                if !is_instance_valid(_character):
                    continue
                if characterConfig.name == _character.config.name:
                    continue
                if !_character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.LILYPAD:
                    continue
                CharacterReplace(_character, character)
                return

    characterList.append(character)

    for type: TowerDefenseEnum.PLANTGRIDTYPE in gridType:
        if is_instance_valid(slot[type]):
            if characterConfig.plantGridType.has(type):
                var isPlantCharacter: TowerDefenseCharacter = slot[type]
                var isPlantCharacterConfig: TowerDefenseCharacterConfig = isPlantCharacter.config
                if isPlantCharacterConfig.plantGridType.has(characterConfig.plantGridOverrideType):
                    slot[type] = character
                    characterSlotDictionary[character] = isPlantCharacter
                    return

    characterSlotDictionary[character] = null
    character.destroy.connect(CharacterDestroy)

    for type: TowerDefenseEnum.PLANTGRIDTYPE in gridType:
        if characterConfig.plantGridType.has(type):
            if !is_instance_valid(slot[type]):
                slot[type] = character
                return


    var slotCharacter: TowerDefenseCharacter = GetCharacterWhoHasGridType(packetConfig)
    if slotCharacter:
        characterSlotDictionary[slotCharacter] = character
    return

func CharacterReplace(character: TowerDefenseCharacter, replaceCharacter: TowerDefenseCharacter) -> void :
    ClearEmpty()
    replaceCharacter.destroy.connect(CharacterDestroy)
    characterList.append(replaceCharacter)
    characterSlotDictionary[replaceCharacter] = characterSlotDictionary[character]
    var flag: bool = false
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        flag = true
    if characterSurround == character:
        characterSurround = replaceCharacter
    for slotCharacter: TowerDefenseCharacter in characterSlotDictionary.keys():
        if characterSlotDictionary[slotCharacter] == character:
            if !flag:
                replaceCharacter.Cover(character)
                flag = true
            characterSlotDictionary[slotCharacter] = replaceCharacter
    for type: TowerDefenseEnum.PLANTGRIDTYPE in gridType:
        if is_instance_valid(slot[type]):
            if slot[type] == character:
                if !flag:
                    replaceCharacter.Cover(character)
                    flag = true
                slot[type] = replaceCharacter
                break
    character.Destroy()

func CharacterDestroy(character: TowerDefenseCharacter) -> void :
    ClearEmpty()
    if character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.NUT:
        if is_instance_valid(characterLadder):
            characterLadder.Destroy()

    for characterKey in characterSlotDictionary.keys():
        if !is_instance_valid(characterSlotDictionary[characterKey]) || characterSlotDictionary[characterKey] == character:
            characterSlotDictionary[characterKey] = null

    for slotKey in slot.keys():
        if !is_instance_valid(slot[slotKey]) || slot[slotKey] == character:
            slot[slotKey] = null

    characterList.erase(character)
    characterSlotDictionary.erase(character)
    return

func GetCharacterListSave() -> Array[TowerDefenseCharacter]:
    ClearEmpty()
    var characterListGet: Array[TowerDefenseCharacter] = []
    if gridType.has(TowerDefenseEnum.PLANTGRIDTYPE.SOIL):
        if is_instance_valid(slot[TowerDefenseEnum.PLANTGRIDTYPE.SOIL]):
            characterListGet.append(slot[TowerDefenseEnum.PLANTGRIDTYPE.SOIL])
    if gridType.has(TowerDefenseEnum.PLANTGRIDTYPE.BRICK):
        if is_instance_valid(slot[TowerDefenseEnum.PLANTGRIDTYPE.BRICK]):
            characterListGet.append(slot[TowerDefenseEnum.PLANTGRIDTYPE.BRICK])
    if gridType.has(TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        if is_instance_valid(slot[TowerDefenseEnum.PLANTGRIDTYPE.WATER]):
            characterListGet.append(slot[TowerDefenseEnum.PLANTGRIDTYPE.WATER])
    for character: TowerDefenseCharacter in characterList:
        if characterListGet.has(character):
            continue
        if character == characterLadder:
            continue
        if character == characterSurround:
            continue
        characterListGet.append(character)
    if is_instance_valid(characterSurround):
        characterListGet.append(characterSurround)
    if is_instance_valid(characterLadder):
        characterListGet.append(characterLadder)
    return characterListGet

func GetCharacterList() -> Array[TowerDefenseCharacter]:
    return characterList

func GetGridType() -> Array[TowerDefenseEnum.PLANTGRIDTYPE]:
    return gridType

func GetCharacterWhoHasGridType(packetConfig: TowerDefensePacketConfig) -> TowerDefenseCharacter:
    ClearEmpty()
    var _gridType: Array[TowerDefenseEnum.PLANTGRIDTYPE] = packetConfig.characterConfig.plantGridType
    for character: TowerDefenseCharacter in characterList:
        if !character:
            character = null
        if !is_instance_valid(character) || is_instance_valid(characterSlotDictionary[character]):
            continue
        if character:
            var characterConfig: TowerDefenseCharacterConfig = character.config
            if characterConfig.plantGridOverrideType == TowerDefenseEnum.PLANTGRIDTYPE.NOONE:
                continue
            if characterConfig.plantGridOverrideType == packetConfig.characterConfig.plantGridOverrideType:
                continue
            if _gridType.has(characterConfig.plantGridOverrideType):
                return character
    return null

func CanPacketPlant(packetConfig: TowerDefensePacketConfig, noLimit: bool = false) -> bool:
    ClearEmpty()
    var characterConfig: TowerDefenseCharacterConfig = packetConfig.characterConfig

    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        if HasVase() && !packetConfig.characterConfig is TowerDefenseVaseConfig:
            return true

    if characterConfig.plantGridType.has(TowerDefenseEnum.PLANTGRIDTYPE.ALL):
        return true

    if characterConfig is TowerDefenseItemConfig:
        if characterConfig.isLadder:
            return HasWallnut() && !is_instance_valid(characterLadder)

    var iceCap = TowerDefenseMapControl.instance.iceCapList[gridPos.y]
    if is_instance_valid(iceCap):
        if !characterConfig.plantGridType.has(TowerDefenseEnum.PLANTGRIDTYPE.GRAVESTONE) && !characterConfig.plantGridType.has(TowerDefenseEnum.PLANTGRIDTYPE.AIR):
            if TowerDefenseManager.GetMapGridPos(iceCap.iceCapSprite.global_position).x <= gridPos.x:
                return false

    for type: TowerDefenseEnum.PLANTGRIDTYPE in gridType:
        if is_instance_valid(slot[type]):
            if slot[type] is TowerDefenseGravestone:
                if !characterConfig.plantGridType.has(TowerDefenseEnum.PLANTGRIDTYPE.GRAVESTONE) && !characterConfig.plantGridType.has(TowerDefenseEnum.PLANTGRIDTYPE.AIR):
                    return false
            if slot[type] is TowerDefenseCrater:
                if !characterConfig.plantGridType.has(TowerDefenseEnum.PLANTGRIDTYPE.AIR):
                    return false

    if !packetConfig.GetPlantCover().is_empty():
        if noLimit:
            return true
        for character: TowerDefenseCharacter in characterList:
            if !is_instance_valid(character):
                continue
            if packetConfig.GetPlantCover().has(character.config.name):
                return true
        if !packetConfig.GetCoverCanDirectPlant():
            return false

    var nutBandaging: bool = GameSaveManager.GetFeatureValue("NutBandaging") > 0
    var potReplacement: bool = GameSaveManager.GetFeatureValue("PotReplacement") > 0

    if characterConfig.plantGridType.has(TowerDefenseEnum.PLANTGRIDTYPE.SURROUND):
        var surroundPlantFlag: bool = true
        for type: TowerDefenseEnum.PLANTGRIDTYPE in gridType:
            if !is_instance_valid(slot[type]):
                if SURROUND_UNCLUDE_GRID.has(type):
                    surroundPlantFlag = false
                    break;
        if surroundPlantFlag:
            if !is_instance_valid(characterSurround):
                return true

    if packetConfig == null:
        return false

    if nutBandaging && characterConfig.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.NUT:
        for character: TowerDefenseCharacter in characterList:
            if !is_instance_valid(character):
                continue
            if characterConfig.name != character.config.name:
                continue
            if !character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.NUT:
                continue
            if character.instance.damagePointIndex <= 1:
                continue
            return true

    if potReplacement:
        if characterConfig.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.POT:
            for character: TowerDefenseCharacter in characterList:
                if !is_instance_valid(character):
                    continue
                if characterConfig.name == character.config.name:
                    continue
                if !character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.POT:
                    continue
                return true
        if characterConfig.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.LILYPAD:
            for character: TowerDefenseCharacter in characterList:
                if !is_instance_valid(character):
                    continue
                if characterConfig.name == character.config.name:
                    continue
                if !character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.LILYPAD:
                    continue
                return true

    for type: TowerDefenseEnum.PLANTGRIDTYPE in gridType:
        if is_instance_valid(slot[type]):
            if characterConfig.plantGridType.has(type):
                var isPlantCharacter: TowerDefenseCharacter = slot[type]
                var isPlantCharacterConfig: TowerDefenseCharacterConfig = isPlantCharacter.config
                if isPlantCharacterConfig.plantGridType.has(characterConfig.plantGridOverrideType):
                    return true

    for type: TowerDefenseEnum.PLANTGRIDTYPE in gridType:
        if !is_instance_valid(slot[type]):
            if characterConfig.plantGridType.has(type):
                return true

    if characterConfig is TowerDefensePlantConfig || characterConfig is TowerDefenseGravestoneConfig:
        if GetCharacterWhoHasGridType(packetConfig):
            return true

    return false

func CanShovel(pecentage: float) -> bool:
    return GetShovelCharacter(pecentage) != null

func GetShovelCharacter(pecentage: float) -> TowerDefenseCharacter:
    ClearEmpty()
    if pecentage < 0.25:
        if gridType.has(TowerDefenseEnum.PLANTGRIDTYPE.AIR):
            if is_instance_valid(slot[TowerDefenseEnum.PLANTGRIDTYPE.AIR]):
                return slot[TowerDefenseEnum.PLANTGRIDTYPE.AIR]
    if pecentage > 0.5:
        if is_instance_valid(characterSurround):
            return characterSurround

    for characterKey: TowerDefenseCharacter in characterSlotDictionary.keys():
        if is_instance_valid(characterSlotDictionary[characterKey]):
            if !characterSlotDictionary[characterKey] is TowerDefenseGravestone && !characterSlotDictionary[characterKey] is TowerDefenseCrater:
                return characterSlotDictionary[characterKey]
    for characterKey: TowerDefenseEnum.PLANTGRIDTYPE in slot.keys():
        if is_instance_valid(slot[characterKey]):
            if !slot[characterKey] is TowerDefenseGravestone && !slot[characterKey] is TowerDefenseCrater:
                return slot[characterKey]
    for character: TowerDefenseCharacter in characterList:
        if !character is TowerDefenseGravestone && !character is TowerDefenseCrater:
            return character
    if is_instance_valid(characterSurround):
        return characterSurround
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
            if character.gridPos == gridPos:
                return character
    return null

func Shovel(shovelConfig: ShovelConfig, pecentage: float) -> void :
    var character: TowerDefenseCharacter = GetShovelCharacter(pecentage)
    if character:
        if character is TowerDefensePlant || (Global.isEditor && SceneManager.currentScene == "LevelEditorStage"):
            var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
            var plantedEffect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(DIRT, character.gridPos)
            characterNode.add_child(plantedEffect)
            plantedEffect.global_position = character.transformPoint.global_position
            shovelConfig.Execute(character)
            return

func CanPlantfood() -> bool:
    for character: TowerDefenseCharacter in characterList:
        if !character:
            character = null
        if character:
            if character is TowerDefensePlant:
                if character.config.canUsePlantfood && !character.plantfoodMode:
                    return true
    return false

func GetPlantfoodCharacter() -> TowerDefenseCharacter:
    for character: TowerDefenseCharacter in characterList:
        if !character:
            character = null
        if character:
            if character is TowerDefensePlant:
                if character.config.canUsePlantfood && !character.plantfoodMode:
                    return character
    return null

func Plantfood() -> void :
    for character: TowerDefenseCharacter in characterList:
        if !character:
            character = null
        if character:
            if character is TowerDefensePlant:
                if character.config.canUsePlantfood && !character.plantfoodMode:
                    character.Plantfood()
                return

func GetTarget(maskFlags: int = 0) -> TowerDefenseCharacter:
    ClearEmpty()
    if is_instance_valid(characterSurround):
        return characterSurround
    for characterKey: TowerDefenseCharacter in characterSlotDictionary.keys():
        if is_instance_valid(characterSlotDictionary[characterKey]):
            if characterSlotDictionary[characterKey] is TowerDefenseGravestone:
                continue
            if characterSlotDictionary[characterKey] is TowerDefenseCrater:
                continue
            if characterSlotDictionary[characterKey].CanCollision(maskFlags):
                return characterSlotDictionary[characterKey]
    for characterKey: TowerDefenseEnum.PLANTGRIDTYPE in slot.keys():
        if is_instance_valid(slot[characterKey]):
            if slot[characterKey] is TowerDefenseGravestone:
                continue
            if slot[characterKey] is TowerDefenseCrater:
                continue
            if slot[characterKey].CanCollision(maskFlags):
                return slot[characterKey]
    for character: TowerDefenseCharacter in characterList:
        if character is TowerDefenseGravestone:
            continue
        if character is TowerDefenseCrater:
            continue
        if is_instance_valid(character):
            return character
    return null

func GetSlot(character: TowerDefenseCharacter) -> TowerDefenseCharacter:
    if !is_instance_valid(character):
        return null
    if characterSlotDictionary.has(character) && is_instance_valid(characterSlotDictionary[character]):
        var slotCharacter: TowerDefenseCharacter = characterSlotDictionary[character]
        if is_instance_valid(slotCharacter):
            return slotCharacter
    return null

func GetSurround() -> TowerDefenseCharacter:
    if is_instance_valid(characterSurround):
        return characterSurround
    return null

func FindSlotParent(character: TowerDefenseCharacter) -> TowerDefenseCharacter:
    for key in characterSlotDictionary.keys():
        if characterSlotDictionary[key] == character:
            return key
    return null

func HasWallnut() -> bool:
    ClearEmpty()
    for character: TowerDefenseCharacter in characterList:
        if is_instance_valid(character):
            if character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.NUT:
                return true
    return false

func HasVase() -> bool:
    ClearEmpty()
    for character: TowerDefenseCharacter in characterList:
        if is_instance_valid(character):
            if character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.VASE:
                return true
    return false

func HasLight() -> bool:
    ClearEmpty()
    for character: TowerDefenseCharacter in characterList:
        if is_instance_valid(character):
            if character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.LIGHT:
                return true
    return false

func HasCoffee() -> bool:
    ClearEmpty()
    for character: TowerDefenseCharacter in characterList:
        if is_instance_valid(character):
            if character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.COFFEE:
                return true
    return false

func GetVase() -> TowerDefenseCharacter:
    ClearEmpty()
    for character: TowerDefenseCharacter in characterList:
        if is_instance_valid(character):
            if character.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.VASE:
                return character
    return null

func IsWater() -> bool:
    return gridType.has(TowerDefenseEnum.PLANTGRIDTYPE.WATER)

func CanCraterCreate() -> bool:
    ClearEmpty()
    for type: TowerDefenseEnum.PLANTGRIDTYPE in gridType:
        if is_instance_valid(slot[type]):
            return false
    return true

func GetGroundHeight(percentage: float = 0.5) -> float:
    if !groundHeightCurve:
        return 0
    else:
        return groundHeightCurve.curve.sample(percentage)

func HasPlant() -> bool:
    var list = characterList.filter(
        func(character):
            return character is TowerDefensePlant
    )
    return !list.is_empty()

func CanMowerMove() -> bool:
    if characterList.size() <= 0:
        return false
    for character: TowerDefenseCharacter in characterList:
        if !character.canMowerMove:
            return false
    return true

func CanMoveToCell(cell: TowerDefenseCellInstance) -> bool:
    if cell.characterList.size() > 0:
        return false
    return gridType == cell.gridType

func MoveToCell(cell: TowerDefenseCellInstance) -> void :
    cell.characterList = characterList.duplicate()
    cell.characterSlotDictionary = characterSlotDictionary.duplicate()
    cell.slot = slot.duplicate()
    if is_instance_valid(characterSurround):
        cell.characterSurround = characterSurround
    if is_instance_valid(characterLadder):
        cell.characterLadder = characterLadder

    for character: TowerDefenseCharacter in characterList:
        if character.destroy.is_connected(CharacterDestroy):
            character.destroy.disconnect(CharacterDestroy)
        character.destroy.connect(cell.CharacterDestroy)
        var tween = character.create_tween()
        tween.set_parallel(true)
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_QUART)
        tween.tween_property(character, ^"global_position", TowerDefenseManager.GetMapCellPlantPos(cell.gridPos), 0.5)
        tween.tween_property(character, ^"saveShadowPosition", character.saveShadowPosition + TowerDefenseManager.GetMapCellPlantPos(cell.gridPos) - character.global_position, 0.5)
        character.gridPos = cell.gridPos

    characterList.clear()
    characterSlotDictionary.clear()
    slot.clear()
    characterSurround = null
    characterLadder = null
    for type: TowerDefenseEnum.PLANTGRIDTYPE in gridType:
        slot[type] = null
