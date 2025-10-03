@tool
class_name TowerDefensePacketConfig extends Resource
const DIRT = preload("uid://tyehajadw7d1")
@export var saveKey: String = ""
@export var unlockCheckList: Array[UnlockConditionBaseConfig]
@export var name: String
@export var describe: String
@export var plantfood: String
@export var handbookDescribe: String
@export var handbookStory: String
@export var packetAnimeClip: String = "Idle"
@export var packetAnimeOffset: Vector2 = Vector2.ZERO
@export var packetAnimeScale: Vector2 = Vector2.ZERO
@export var characterConfig: TowerDefenseCharacterConfig:
    set(_characterConfig):
        characterConfig = _characterConfig
        notify_property_list_changed()
@export var type: TowerDefenseEnum.PACKET_TYPE = TowerDefenseEnum.PACKET_TYPE.WHITE
@export_category("Spawn")
@export_enum("Noone", "Rise", "FlyDown") var spawnMethod: String = "Rise"
@export_category("Event")
@export var eventPress: Array[TowerDefensePacketEventBase]
@export var eventPlant: Array[TowerDefensePacketEventBase]
@export_category("Override")
@export var override: TowerDefensePacketOverride
@export var overrideCostRise: int = -1
@export var overrideCost: int = -1
@export var overridePacketCooldown: float = -1
@export var overrideStartingCooldown: float = -1
@export_storage var overrideWeight: int = -1
@export_storage var overrideWavePointCost: int = -1
@export_category("Other")
@export_storage var initArmor: Array[String]
@export_storage var plantUseCell: bool = true

func _get_property_list() -> Array[Dictionary]:
    var properties: Array[Dictionary] = []

    if characterConfig:
        if characterConfig.armorData:
            properties.append(
                {
                    "name": "Armor", 
                    "type": TYPE_ARRAY, 
                    "hint": PROPERTY_HINT_ENUM, 
                    "hint_string": "%d/%d:%s" % [TYPE_STRING, PROPERTY_HINT_ENUM, ",".join(characterConfig.armorData.armorDictionary.keys())], 
                }
            )
        properties.append(
            {
                "name": "Cell/plantUseCell", 
                "type": TYPE_BOOL
            }
        )
        if characterConfig is TowerDefenseZombieConfig:
            properties.append(
                {
                    "name": "Override/overrideWeight", 
                    "type": TYPE_INT
                }
            )
            properties.append(
                {
                    "name": "Override/overrideWavePointCost", 
                    "type": TYPE_INT
                }
            )
    return properties

func _set(property: StringName, value: Variant) -> bool:
    match property:
        "Armor":
            initArmor = value
            return true
        "Override/overrideWeight":
            overrideWeight = value
            return true
        "Override/overrideWavePointCost":
            overrideWavePointCost = value
            return true
        "Cell/plantUseCell":
            plantUseCell = value
            return true
    return false

func _get(property: StringName) -> Variant:
    match property:
        "Armor":
            return initArmor
        "Override/overrideWeight":
            return overrideWeight
        "Override/overrideWavePointCost":
            return overrideWavePointCost
        "Cell/plantUseCell":
            return plantUseCell
    return null

func _property_can_revert(property: StringName) -> bool:
    match property:
        "Armor":
            return true
        "Override/overrideWeight":
            return true
        "Override/overrideWavePointCost":
            return true
        "Cell/plantUseCell":
            return true
    return false

func _property_get_revert(property: StringName) -> Variant:
    match property:
        "Armor":
            return Array([], TYPE_STRING, "", null)
        "Override/overrideWeight":
            return -1
        "Override/overrideWavePointCost":
            return -1
        "Cell/plantUseCell":
            return true
    return null

func GetType() -> TowerDefenseEnum.PACKET_TYPE:
    if is_instance_valid(override):
        if override.type != TowerDefenseEnum.PACKET_TYPE.NOONE:
            return override.type
    return type

func GetCostRise() -> int:
    if is_instance_valid(override):
        if override.costRise != -1:
            return override.costRise
    if overrideCostRise != -1:
        return overrideCostRise
    return characterConfig.costRise

func GetCost() -> int:
    if is_instance_valid(override):
        if override.cost != -1:
            return override.cost
    if overrideCost != -1:
        return overrideCost
    return characterConfig.cost

func GetPacketCooldown() -> float:
    if is_instance_valid(override):
        if override.packetCooldown != -1:
            return override.packetCooldown
    if overridePacketCooldown != -1:
        return overridePacketCooldown
    return characterConfig.packetCooldown

func GetStartingCooldown() -> float:
    if is_instance_valid(override):
        if override.startingCooldown != -1:
            return override.startingCooldown
    if overrideStartingCooldown != -1:
        return overrideStartingCooldown
    return characterConfig.startingCooldown

func GetWeight() -> int:
    if is_instance_valid(override):
        if override.weight != -1:
            return override.weight
    if overrideWeight != -1:
        return overrideWeight
    return characterConfig.weight

func GetWavePointCost() -> int:
    if is_instance_valid(override):
        if override.wavePointCost != -1:
            return override.wavePointCost
    if overrideWavePointCost != -1:
        return overrideWavePointCost
    return characterConfig.wavePointCost

func GetPlantCover() -> Array[String]:
    if is_instance_valid(override):
        if override.plantCover.size() > 0:
            return override.plantCover
    return characterConfig.plantCover

func GetCoverCanDirectPlant() -> bool:
    if is_instance_valid(override):
        return override.coverCanDirectPlant
    return false

func IsLimitGridNum() -> bool:
    if is_instance_valid(override):
        return override.islimitGridNum
    return true

func ExecuteEventPress(packet: TowerDefenseInGamePacketShow) -> void :
    var eventList: Array[TowerDefensePacketEventBase] = eventPress
    if is_instance_valid(override):
        if override.eventPress.size() > 0:
            eventList = override.eventPress
    for event: TowerDefensePacketEventBase in eventList:
        event.Execute(packet)

func ExecuteEventPlant(packet: TowerDefenseInGamePacketShow) -> void :
    var eventList: Array[TowerDefensePacketEventBase] = eventPlant
    if is_instance_valid(override):
        if override.eventPlant.size() > 0:
            eventList = override.eventPlant
    for event: TowerDefensePacketEventBase in eventList:
        event.Execute(packet)

func Plant(gridPos: Vector2i, playAudio: bool = true, noLimit: bool = false) -> TowerDefenseCharacter:
    var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(gridPos)
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        if !characterConfig is TowerDefenseVaseConfig && cell.HasVase():
            var vase = cell.GetVase() as TowerDefenseVase
            vase.packetConfig = self.duplicate(true)
            return null
    if !characterConfig is TowerDefenseZombieConfig && !is_instance_valid(cell):
        return null
    if !characterConfig is TowerDefenseZombieConfig && !cell.CanPacketPlant(self, noLimit):
        return null
    var charcaterName: String = characterConfig.name
    var chacraterScene: PackedScene = TowerDefenseManager.GetChacraterScene(charcaterName)
    var character: TowerDefenseCharacter = chacraterScene.instantiate()
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        character.inGame = false
    if characterConfig.armorData:
        if initArmor.size() > 0:
            for armor: String in initArmor:
                character.currentArmor.append(armor)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var plantPos: Vector2 = TowerDefenseManager.GetMapCellPlantPos(gridPos)
    character.global_position = plantPos / TowerDefenseMapControl.instance.global_scale.y
    character.gridPos = gridPos
    character.cost = characterConfig.cost
    character.packet = self
    if is_instance_valid(cell):
        character.groundHeight = cell.GetGroundHeight(0.5)
    character.z = character.groundHeight
    characterNode.add_child(character)
    if is_instance_valid(override):
        if is_instance_valid(override.characterOverride):
            override.characterOverride.ExecuteCharacter(character)
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        character.sprite.process_mode = Node.PROCESS_MODE_ALWAYS
        character.state.process_mode = Node.PROCESS_MODE_DISABLED
        for component in character.get_children(true):
            if component is ComponentBase:
                if component is SlotComponent:
                    continue
                component.process_mode = Node.PROCESS_MODE_DISABLED
        character.sprite.SetAnimation(packetAnimeClip, true)
    var saveIndex: int = -1
    var maxX: int = -1
    for nodeId in characterNode.get_child_count():
        var node: Node = characterNode.get_child(nodeId)
        if node is TowerDefenseCharacter:
            if node == character:
                continue
            if node.itemLayer != character.itemLayer:
                continue
            if node.gridPos.y != character.gridPos.y:
                continue
            if node.gridPos.x > maxX && node.gridPos.x <= character.gridPos.x:
                maxX = node.gridPos.x
                saveIndex = nodeId
    if saveIndex != -1:
        characterNode.move_child(character, saveIndex)

    if overrideCost != -1:
        character.cost = characterConfig.cost
    var plantedEffect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(DIRT, gridPos)
    characterNode.add_child(plantedEffect)
    plantedEffect.global_position = character.transformPoint.global_position
    if plantUseCell && ( !characterConfig is TowerDefenseZombieConfig):
        cell.CharacterPlant(self, character, noLimit)

    if is_instance_valid(TowerDefenseManager.currentControl) && TowerDefenseManager.currentControl.isGameRunning:
        if !Global.isEditor || SceneManager.currentScene != "LevelEditorStage":
            if characterConfig is TowerDefenseZombieConfig:
                if character is TowerDefenseZombie:
                    IsZombieWalk(character)

    if playAudio:
        if is_instance_valid(cell) && cell.gridType.has(TowerDefenseEnum.PLANTGRIDTYPE.WATER):
            AudioManager.AudioPlay("PlantWater", AudioManagerEnum.TYPE.SFX)
        else:
            AudioManager.AudioPlay("Plant", AudioManagerEnum.TYPE.SFX)

    return character

func HasSpawnLimit() -> bool:
    if characterConfig is TowerDefenseZombieConfig:
        if characterConfig.spawnLineNeed.size() > 0:
            return true
        if characterConfig.excludeLineGridType.size() > 0:
            return true
    return false

func CanSpawn(line: int) -> bool:
    var flag: bool = true
    if characterConfig is TowerDefenseZombieConfig:
        for gridType: TowerDefenseEnum.PLANTGRIDTYPE in characterConfig.spawnLineNeed:
            if !TowerDefenseMapControl.instance.LineHasType(line, gridType):
                flag = false
                break
        for gridType: TowerDefenseEnum.PLANTGRIDTYPE in characterConfig.excludeLineGridType:
            if TowerDefenseMapControl.instance.LineHasType(line, gridType):
                flag = false
                break
    return flag

func Spawn(line: int, offsetX: float = 0.0, isIdle: bool = false) -> TowerDefenseCharacter:
    var charcaterName: String = characterConfig.name
    var chacraterScene: PackedScene = TowerDefenseManager.GetChacraterScene(charcaterName)
    var character: TowerDefenseCharacter = chacraterScene.instantiate()
    if characterConfig.armorData:
        if initArmor.size() > 0:
            for armor: String in initArmor:
                character.currentArmor.append(armor)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var mapControl: TowerDefenseMapControl = TowerDefenseManager.GetMapControl()
    var spawnPos: Vector2 = Vector2(mapControl.config.edge.z + 40 + offsetX, TowerDefenseManager.GetMapLineY(line))
    character.global_position = spawnPos
    character.gridPos = Vector2i(-1, line)
    characterNode.add_child(character)
    if !isIdle:
        match spawnMethod:
            "Rise":
                character.Rise()
            "FlyDown":
                character.z = 900

    if !isIdle:
        if characterConfig is TowerDefenseZombieConfig:
            if character is TowerDefenseZombie:
                IsZombieWalk(character)
    RandomAnime(character)
    return character

func Create(pos: Vector2, gridPos: Vector2, height: float = 0.0) -> TowerDefenseCharacter:
    var charcaterName: String = characterConfig.name
    var chacraterScene: PackedScene = TowerDefenseManager.GetChacraterScene(charcaterName)
    var character: TowerDefenseCharacter = chacraterScene.instantiate()
    if characterConfig.armorData:
        if initArmor.size() > 0:
            for armor: String in initArmor:
                character.currentArmor.append(armor)
    character.z = height
    character.global_position = pos
    character.gridPos = gridPos
    return character

func RandomAnime(character: TowerDefenseCharacter):
    if is_instance_valid(character):
        character.sprite.frameIndex += randi_range(0, 20)

func IsZombieWalk(character: TowerDefenseCharacter):
    await character.get_tree().physics_frame
    if !character.die && !character.nearDie && !character.isRise:
        character.Walk.call_deferred()

func Unlock() -> bool:
    if Global.debugPacketOpenAll:
        return true
    var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(saveKey)
    if !packetValue.get_or_add("Unlock", false):
        if unlockCheckList.size() <= 0:
            return false
        else:
            for unlockCheck: UnlockConditionBaseConfig in unlockCheckList:
                if !unlockCheck.Check():
                    return false
            packetValue["Unlock"] = true
            GameSaveManager.SetTowerDefensePacketValue(saveKey, packetValue)
            GameSaveManager.Save()
    return true
