extends Node

const LEVEL_RESOURCE = preload("res://Asset/Config/Level/LevelResource.json")

const TOWER_DEFENSE_EFFECT_PARTICLES_ONCE: PackedScene = preload("uid://dbyd0mqkya1j3")
const TOWER_DEFENSE_EFFECT_SPRITE_ONCE: PackedScene = preload("uid://dwvgduivkprow")

const TOWER_DEFENSE_SUN = preload("uid://dk3bkihnh1i0l")
const TOWER_DEFENSE_BRAIN_SUN = preload("uid://d161xee5m0kkw")

const TOWER_DEFENSE_IN_GAME_PACKET_SHOW: PackedScene = preload("uid://bhqecss20rwpb")

const TOWER_DEFENSE_AWARD_PACKET = preload("uid://7l7qsvsxvioi")
const TOWER_DEFENSE_AWARD_PURSE = preload("uid://mux1v63kv0d8")
const TOWER_DEFENSE_AWARD_COLLECTABLE = preload("uid://d28midqtre16s")

const ZOMBIE_DEATH_FALLING_OBJECT = preload("uid://ct867xau74s6u")

const TOWER_DEFENSE_PORTAL = preload("uid://dral054wqsme5")

@onready var coinBank: CoinBank = %CoinBank

var currentControl: TowerDefenseControl
@export var currentLevelConfig: TowerDefenseLevelConfig
var currentDynamicLevel: int = 3
var seedbankPacketMax: int = 7



func IsGameRunning() -> bool:
    if is_instance_valid(currentControl):
        return currentControl.isGameRunning
    return false

func GetCharacterNode() -> Node2D:
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage" && is_instance_valid(LevelEditorMapEditor.instance):
        return LevelEditorMapEditor.instance.characterNode
    if !currentControl:
        return ObjectManager
    return currentControl.characterNode





func GetBackgroundMusicConfig(backgroundMusic: String) -> TowerDefenseBackgroundMusicConfig:
    var bgm: TowerDefenseBackgroundMusicConfig = null
    if ResourceManager.BGMS.has(backgroundMusic):
        bgm = ResourceManager.BGMS[backgroundMusic]
    var modBgmGet: TowerDefenseBackgroundMusicConfig = ModManager.FindBgm(backgroundMusic)
    if is_instance_valid(modBgmGet):
        bgm = modBgmGet
    return bgm





func GetPacketBank() -> TowerDefenseInGamePacketBank:
    return currentControl.packetBank

func GetPacketBankData(packetBank: String) -> TowerDefensePacketBankData:
    return ResourceManager.TOWERDEFENSE_PACKETBANKS[packetBank]

func GetPacketConfig(packetName: String) -> TowerDefensePacketConfig:
    return ResourceManager.TOWERDEFENSE_PACKETS[packetName]





func GetSeedBank() -> TowerDefenseInGameSeedBank:
    if currentControl && currentControl.seedBank:
        return currentControl.seedBank
    return null

func GetPacketSlotNum() -> int:
    var num: int = 7
    for id in range(8, 17):
        if GameSaveManager.GetFeatureValue("PacketSlot%d" % id) > 0:
            num += 1
        else:
            break
    seedbankPacketMax = num
    return num

func AddPacket(packetName: String) -> void :
    var seedBank: TowerDefenseInGameSeedBank = GetSeedBank()
    var packetConfig: TowerDefensePacketConfig = GetPacketConfig(packetName)
    seedBank.AddPacket(packetConfig, true)

func AddSun(num: int) -> void :
    var seedBank: TowerDefenseInGameSeedBank = GetSeedBank()
    if seedBank:
        seedBank.AddSun(num)

func UseSun(num: int) -> void :
    var seedBank: TowerDefenseInGameSeedBank = GetSeedBank()
    if seedBank:
        seedBank.UseSun(num)

func SetSun(num: int) -> void :
    var seedBank: TowerDefenseInGameSeedBank = GetSeedBank()
    if seedBank:
        seedBank.SetSun(num)

func GetSun() -> int:
    var seedBank: TowerDefenseInGameSeedBank = GetSeedBank()
    if seedBank:
        return seedBank.sunNum
    return -1





func SetNextLevel(levelChoose: String, chapterId: int, levelId: int) -> TowerDefenseLevelConfig:
    var currentChapter = LEVEL_RESOURCE.data[levelChoose]["Chapter"][chapterId]
    var levelList = currentChapter["Level"]
    if levelId + 1 < levelList.size():
        var nextLevel = levelList[levelId + 1]
        if nextLevel["OpenKey"] == "Lock":
            return null
        if (nextLevel["OpenKey"] != ""):
            var levelData: Dictionary = GameSaveManager.GetLevelValue(nextLevel["OpenKey"])
            if levelData.get_or_add("Key", {}).get_or_add("Finish", 0) <= 0:
                return null
        var difficult: String = GameSaveManager.GetKeyValue("CurrentDifficult")
        if nextLevel["Level"][difficult] != "":
            TowerDefenseManager.currentLevelConfig = load(nextLevel["Level"][difficult])
        else:
            TowerDefenseManager.currentLevelConfig = load(nextLevel["Level"]["Normal"])
        Global.currentLevelId = levelId + 1
        GameSaveManager.SetKeyValue("AdventureChapter%dIndex" % [chapterId + 1], levelId + 1)
        GameSaveManager.Save()
        return TowerDefenseManager.currentLevelConfig
    return null

func GetLevelControl() -> TowerDefenseInGameLevelControl:
    if !currentControl:
        return null
    return currentControl.levelControl

func GetLevelEvent(eventName: String) -> TowerDefenseLevelEventBase:
    return ResourceManager.TOWERDEFENSE_LEVEL_EVENT[eventName].new()

func GetLevelHomeworld() -> GeneralEnum.HOMEWORLD:
    var levelControl: TowerDefenseInGameLevelControl = GetLevelControl()
    if !levelControl:
        return GeneralEnum.HOMEWORLD.NOONE
    return levelControl.config.homeWorld

func ExecuteLevelEvent(eventList: Array[TowerDefenseLevelEventBase]) -> void :
    for event: TowerDefenseLevelEventBase in eventList:
        event.Execute()

func TipsPlay(text: String, duration: float = 2.0):
    var levelControl: TowerDefenseInGameLevelControl = GetLevelControl()
    levelControl.TipsPlay(text, duration)

func CreatePacketShow(packetName: String = ""):
    var config: TowerDefensePacketConfig = null
    if packetName != "":
        config = TowerDefenseManager.GetPacketConfig(packetName)
    var packet: TowerDefenseInGamePacketShow = TOWER_DEFENSE_IN_GAME_PACKET_SHOW.instantiate() as TowerDefenseInGamePacketShow
    if config:
        packet.Init(config)
    return packet

func CreateAward(type: TowerDefenseEnum.LEVEL_REWARDTYPE, itemName: String, pos: Vector2) -> TowerDefenseAwardBase:
    match type:
        TowerDefenseEnum.LEVEL_REWARDTYPE.NOONE:
            var instance = TOWER_DEFENSE_AWARD_PURSE.instantiate()
            var characetNode: Node2D = GetCharacterNode()
            characetNode.add_child(instance)
            instance.global_position = pos
            instance.Init(itemName)
            return instance
        TowerDefenseEnum.LEVEL_REWARDTYPE.PACKET:
            var instance = TOWER_DEFENSE_AWARD_PACKET.instantiate()
            var characetNode: Node2D = GetCharacterNode()
            characetNode.add_child(instance)
            instance.global_position = pos
            instance.Init(itemName)
            return instance
        TowerDefenseEnum.LEVEL_REWARDTYPE.COLLECTABLE:
            var instance = TOWER_DEFENSE_AWARD_COLLECTABLE.instantiate()
            var characetNode: Node2D = GetCharacterNode()
            characetNode.add_child(instance)
            instance.global_position = pos
            instance.Init(itemName)
            return instance
        TowerDefenseEnum.LEVEL_REWARDTYPE.COIN:
            var instance = TOWER_DEFENSE_AWARD_PURSE.instantiate()
            var characetNode: Node2D = GetCharacterNode()
            characetNode.add_child(instance)
            instance.global_position = pos
            instance.Init(itemName)
            return instance
    return null




func GetSunManager() -> TowerDefenseInGameSunManager:
    var levelControl: TowerDefenseInGameLevelControl = GetLevelControl()
    return levelControl.sunManager

func SunCreate(pos: Vector2, sunNum: int, movingMethod: TowerDefenseEnum.SUN_MOVING_METHOD = TowerDefenseEnum.SUN_MOVING_METHOD.LAND, height: float = 0.0, velocity: Vector2 = Vector2.ZERO, gravity: float = 0.0, moveStopTime: float = -1) -> TowerDefenseSun:
    var characterNode: Node2D = GetCharacterNode()
    var sun: TowerDefenseSun = ObjectManager.PoolPop(ObjectManagerConfig.OBJECT.SUN, characterNode)
    sun.global_position = pos
    sun.Init(sunNum, movingMethod, height, velocity, gravity, moveStopTime)
    return sun

func BrainSunCreate(pos: Vector2, sunNum: int, movingMethod: TowerDefenseEnum.SUN_MOVING_METHOD = TowerDefenseEnum.SUN_MOVING_METHOD.LAND, height: float = 0.0, velocity: Vector2 = Vector2.ZERO, gravity: float = 0.0, moveStopTime: float = -1) -> TowerDefenseBrainSun:
    var characterNode: Node2D = GetCharacterNode()
    var sun: TowerDefenseBrainSun = ObjectManager.PoolPop(ObjectManagerConfig.OBJECT.SUN_BRAIN, characterNode)
    sun.global_position = pos
    sun.Init(sunNum, movingMethod, height, velocity, gravity, moveStopTime)
    return sun

func JalapenoSunCreate(pos: Vector2, sunNum: int, movingMethod: TowerDefenseEnum.SUN_MOVING_METHOD = TowerDefenseEnum.SUN_MOVING_METHOD.LAND, height: float = 0.0, velocity: Vector2 = Vector2.ZERO, gravity: float = 0.0, moveStopTime: float = -1) -> TowerDefenseSunJalapeno:
    var characterNode: Node2D = GetCharacterNode()
    var sun: TowerDefenseSunJalapeno = ObjectManager.PoolPop(ObjectManagerConfig.OBJECT.SUN_JALAPENO, characterNode)
    sun.global_position = pos
    sun.Init(sunNum, movingMethod, height, velocity, gravity, moveStopTime)
    return sun





func GetCoin() -> int:
    if coinBank:
        return coinBank.num
    return 0

func AddCoin(num: int) -> void :
    if coinBank:
        coinBank.AddNum(num)

func UseCoin(num: int) -> void :
    if coinBank:
        coinBank.UseCoin(num)





func FallingObjectCreate(pos: Vector2, height: float = 0.0, velocity: Vector2 = Vector2.ZERO, gravity: float = 0.0) -> Node2D:
    var id: ObjectManagerConfig.OBJECT = ZOMBIE_DEATH_FALLING_OBJECT.Pick()
    if id == ObjectManagerConfig.OBJECT.NOONE:
        return null
    return FallingObjectItemCreate(id, pos, height, velocity, gravity)

func FallingObjectItemCreate(id: ObjectManagerConfig.OBJECT, pos: Vector2, height: float = 0.0, velocity: Vector2 = Vector2.ZERO, gravity: float = 0.0) -> Node2D:
    if id == ObjectManagerConfig.OBJECT.NOONE:
        return null
    var characterNode: Node2D = GetCharacterNode()
    var item = ObjectManager.PoolPop(id, characterNode)
    item.global_position = pos
    if item is TowerDefenseCoinBase:
        item.Init(height, velocity, gravity)
    return item





func GetMapControl() -> TowerDefenseMapControl:
    if !is_instance_valid(TowerDefenseMapControl.instance):
        return null
    return TowerDefenseMapControl.instance

func GetCurrentMap() -> TowerDefenseMap:
    var mapControl: TowerDefenseMapControl = GetMapControl()
    return mapControl.currentMap

func GetMapConfig(mapName: String) -> TowerDefenseMapConfig:
    var map: TowerDefenseMapConfig = null
    if ResourceManager.MAPS.has(mapName):
        map = ResourceManager.MAPS[mapName]
    var modMapGet: TowerDefenseMapConfig = ModManager.FindMap(mapName)
    if is_instance_valid(modMapGet):
        map = modMapGet
    return map

func MapChange(map: String, duration: float = 0.0, delay = 0.0) -> void :
    var mapControl: TowerDefenseMapControl = GetMapControl()
    if mapControl:
        var config: TowerDefenseMapConfig = GetMapConfig(map)
        mapControl.MapChange(config, duration, delay)

func GetMapIsNight() -> bool:
    var mapControl: TowerDefenseMapControl = GetMapControl()
    if mapControl:
        var config: TowerDefenseMapConfig = mapControl.config
        return config.isNight
    return false

func SetMapGridType(cellConfig: TowerDefenseCellConfig) -> void :
    var mapControl: TowerDefenseMapControl = GetMapControl()
    mapControl.SetGridType(cellConfig)

func SetMapLineUse(line: int, use: bool) -> void :
    var mapControl: TowerDefenseMapControl = GetMapControl()
    mapControl.SetLineUse(line, use)

func GetMapLineUse(line: int) -> bool:
    var mapControl: TowerDefenseMapControl = GetMapControl()
    return mapControl.lineUse[line]

func GetMapGridNum() -> Vector2i:
    var mapControl: TowerDefenseMapControl = GetMapControl()
    if is_instance_valid(mapControl) && is_instance_valid(mapControl.config):
        return mapControl.config.gridNum
    else:
        return Vector2i(25, 25)

func GetMapGridSize() -> Vector2:
    var mapControl: TowerDefenseMapControl = GetMapControl()
    if is_instance_valid(mapControl) && is_instance_valid(mapControl.config):
        return mapControl.config.gridSize * mapControl.global_scale
    else:
        return Vector2(80.0, 98.0)

func GetMapGridBeginPos() -> Vector2:
    var mapControl: TowerDefenseMapControl = GetMapControl()
    if is_instance_valid(mapControl) && is_instance_valid(mapControl.config):
        return mapControl.config.gridBeginPos * mapControl.global_scale + mapControl.global_position
    else:
        return Vector2(0, 0)

func GetMapGridPosFromMouse(pos: Vector2) -> Vector2i:
    var gridSize: Vector2 = GetMapGridSize()
    var gridBeginPos: Vector2 = GetMapGridBeginPos()
    var gridNum: Vector2i = GetMapGridNum()
    var xPos: int = floor((pos.x - gridBeginPos.x) / gridSize.x)
    var percentage: float = (pos.x - (gridBeginPos.x + xPos * gridSize.x)) / gridSize.x
    for yPos in range(0, gridNum.y, 1):
        var checkPos: Vector2i = Vector2i(xPos, yPos) + Vector2i.ONE
        var cell = GetMapCell(checkPos)
        if is_instance_valid(cell):
            var groundHeight = 0
            if is_instance_valid(cell.groundHeightCurve):
                groundHeight = cell.groundHeightCurve.curve.sample(percentage)
            if pos.y > (gridBeginPos.y + yPos * gridSize.y) - groundHeight && pos.y < (gridBeginPos.y + yPos * gridSize.y) - groundHeight + gridSize.y:
                return checkPos
    return Vector2(0, 0)

func GetMapGridPos(pos: Vector2) -> Vector2i:
    var gridSize: Vector2 = GetMapGridSize()
    var gridBeginPos: Vector2 = GetMapGridBeginPos()
    var gridPos: Vector2i = Vector2i(((pos - gridBeginPos) / gridSize).floor()) + Vector2i.ONE
    return gridPos

func GetMapCellPos(gridPos: Vector2i) -> Vector2:
    gridPos -= Vector2i.ONE
    var gridSize: Vector2 = GetMapGridSize()
    var gridBeginPos: Vector2 = GetMapGridBeginPos()
    var pos: Vector2 = gridBeginPos + Vector2(gridPos) * gridSize
    return pos

func GetMapCellPosCenter(gridPos: Vector2i) -> Vector2:
    gridPos -= Vector2i.ONE
    var gridSize: Vector2 = GetMapGridSize()
    var gridBeginPos: Vector2 = GetMapGridBeginPos()
    var pos: Vector2 = gridBeginPos + Vector2(gridPos) * gridSize + GetMapGridSize() / 2.0
    return pos

func GetMapPlantOffset() -> float:
    var mapControl: TowerDefenseMapControl = GetMapControl()
    if is_instance_valid(mapControl):
        return mapControl.config.plantOffset
    return 50

func GetMapCellPlantPos(gridPos: Vector2i) -> Vector2:
    gridPos -= Vector2i.ONE
    var mapControl: TowerDefenseMapControl = GetMapControl()
    var gridSize: Vector2 = GetMapGridSize()
    var gridBeginPos: Vector2 = GetMapGridBeginPos()
    var pos: Vector2 = gridBeginPos + Vector2(gridPos) * gridSize + Vector2(gridSize.x / 2, GetMapPlantOffset() * mapControl.global_scale.y)
    return pos

func GetMapLineY(line: int) -> float:
    line -= 1
    var mapControl: TowerDefenseMapControl = GetMapControl()
    var gridSize: Vector2 = GetMapGridSize()
    var gridBeginPos: Vector2 = GetMapGridBeginPos()
    var y: float = gridBeginPos.y + line * gridSize.y + GetMapPlantOffset() * mapControl.global_scale.y
    return y

func CheckMapGridPosIn(gridPos: Vector2i) -> bool:
    var gridNum: Vector2i = GetMapGridNum()
    if gridPos.x < 1 || gridPos.y < 1 || gridPos.x > gridNum.x || gridPos.y > gridNum.y:
        return false
    return true

func GetMapCell(gridPos: Vector2i) -> TowerDefenseCellInstance:
    var mapControl: TowerDefenseMapControl = GetMapControl()
    if !is_instance_valid(mapControl):
        return null
    var gridNum: Vector2i = GetMapGridNum()
    if gridPos.x < 1 || gridPos.y < 1 || gridPos.x > gridNum.x || gridPos.y > gridNum.y:
        return null
    if mapControl.plantGrid.size() <= gridPos.x:
        return null
    if mapControl.plantGrid[gridPos.x][gridPos.y] == null:
        return null
    return mapControl.plantGrid[gridPos.x][gridPos.y]


func GetMapGroundLeft() -> float:
    var gridBeginPos: Vector2 = GetMapGridBeginPos()
    return gridBeginPos.x

func GetMapGroundRight() -> float:
    var gridNum: Vector2i = GetMapGridNum()
    var gridBeginPos: Vector2 = GetMapGridBeginPos()
    var gridSize: Vector2 = GetMapGridSize()
    return gridBeginPos.x + gridNum.x * gridSize.x

func GetMapGroundUp() -> float:
    var gridBeginPos: Vector2 = GetMapGridBeginPos()
    return gridBeginPos.y

func GetMapGroundDown() -> float:
    var gridNum: Vector2i = GetMapGridNum()
    var gridBeginPos: Vector2 = GetMapGridBeginPos()
    var gridSize: Vector2 = GetMapGridSize()
    return gridBeginPos.y + gridNum.y * gridSize.y





func GetMowerConfig(mowerName: String) -> MowerConfig:
    return ResourceManager.MOWERS[mowerName]

func GetMowerList() -> Array:
    return ResourceManager.MOWERS.keys()

func GetMowerNum() -> int:
    return GetMower().size()

func GetMower() -> Array:
    return get_tree().get_nodes_in_group("Mower")

func CreateMower(line: int) -> TowerDefenseMower:
    var mapControl: TowerDefenseMapControl = GetMapControl()
    return mapControl.CreateMower(line)





func GetCharacterSprite(charcterSpriteName: String) -> AdobeAnimateSprite:
    return ResourceManager.CHARCTAER_SPRITE[charcterSpriteName].instantiate()

func GetChacraterScene(charcterName: String) -> PackedScene:
    return ResourceManager.TOWERDEFENSE_CHARCATERS[charcterName]

func CreateCharacter(characterName: String, gridPos: Vector2i = Vector2i(-1, -1)) -> TowerDefenseCharacter:
    var characterScene: PackedScene = GetChacraterScene(characterName)
    var character: TowerDefenseCharacter = characterScene.instantiate() as TowerDefenseCharacter
    character.gridPos = gridPos
    return character





func GetShovel(shovelName: String) -> ShovelConfig:
    return ResourceManager.SHOVELS[shovelName]

func GetShovelList() -> Array:
    return ResourceManager.SHOVELS.keys()





func GetCollectable(collectableName: String) -> CollectableConfig:
    return ResourceManager.COLLECTABLES[collectableName]





func GetTutorial(tutorialName: String) -> TutorialConfig:
    return ResourceManager.TUTORIALS[tutorialName]





func GetNpcTalk(npcTalkName: String) -> NpcTalkConfig:
    return ResourceManager.TALKS[npcTalkName]





func GetProjectileConfig(projectileName: String) -> TowerDefenseProjectileConfig:
    return ResourceManager.PROJECTILE_CONFIG[projectileName]





func GetEffectSprite(effectSpriteName: String) -> AdobeAnimateSprite:
    return ResourceManager.EFFECT_SPRITE[effectSpriteName].instantiate()

func CreateEffectParticlesOnce(scene: PackedScene, gridPos: Vector2i = Vector2i(-1, -1)) -> TowerDefenseEffectParticlesOnce:
    var effect: TowerDefenseEffectParticlesOnce = TOWER_DEFENSE_EFFECT_PARTICLES_ONCE.instantiate() as TowerDefenseEffectParticlesOnce
    effect.Init(scene)
    effect.gridPos = gridPos
    return effect

func CreateEffectSpriteOnce(scene: PackedScene, gridPos: Vector2i = Vector2i(-1, -1), clip: String = "") -> TowerDefenseEffectSpriteOnce:
    var effect: TowerDefenseEffectSpriteOnce = TOWER_DEFENSE_EFFECT_SPRITE_ONCE.instantiate() as TowerDefenseEffectSpriteOnce
    effect.Init(scene, clip)
    effect.gridPos = gridPos
    return effect

func GetEffectDirtName() -> String:
    var homeWorld: GeneralEnum.HOMEWORLD = GetLevelHomeworld()
    if !ResourceManager.EFFECT_DIRT_NAME.has(homeWorld):
        return "DirtSpawnDirt"
    return ResourceManager.EFFECT_DIRT_NAME[homeWorld]





func GetPlant() -> Array:
    var plantList = get_tree().get_nodes_in_group("Plant")
    return plantList

func GetZombie() -> Array:
    var zombieList = get_tree().get_nodes_in_group("Zombie")
    return zombieList

func GetCharacter() -> Array:
    var characterList = get_tree().get_nodes_in_group("Character").filter(
        func(character):
            return !character.characterFilter
    )
    return characterList

func GetProjectile() -> Array:
    var projectileList = get_tree().get_nodes_in_group("Projectile")
    return projectileList

func GetEffect() -> Array:
    var effectList = get_tree().get_nodes_in_group("Effect")
    return effectList

func GetCampTarget(camp: TowerDefenseEnum.CHARACTER_CAMP, fliterGraveStone: bool = true) -> Array:
    var characterList = get_tree().get_nodes_in_group("Character").filter(
        func(checkCharacter: TowerDefenseCharacter):
            if checkCharacter is TowerDefenseCrater:
                return false
            if checkCharacter is TowerDefenseItem:
                return false
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    return false

            return checkCharacter.camp != camp
    )
    return characterList

func GetCharacterNum(characterName: String, containConveyor: bool = false) -> int:
    var num: int = GetCharacterFromName(characterName).size()
    if containConveyor:
        var seedbank: TowerDefenseInGameSeedBank = GetSeedBank()
        if GameSaveManager.GetConfigValue("MobilePreset"):
            var conveyor: TowerDefenseConveyorBelt = seedbank.mobileConveyorBelt
            for packet: TowerDefenseInGamePacketShow in conveyor.mobilePacketContainer1.get_children():
                if packet.config.saveKey == characterName:
                    num += 1
            for packet: TowerDefenseInGamePacketShow in conveyor.mobilePacketContainer2.get_children():
                if packet.config.saveKey == characterName:
                    num += 1
        else:
            var conveyor: TowerDefenseConveyorBelt = seedbank.conveyorBelt
            for packet: TowerDefenseInGamePacketShow in conveyor.packetContainer.get_children():
                if packet.config.saveKey == characterName:
                    num += 1
    return num

func GetCharacterFromName(characterName: String) -> Array:
    var characterList = get_tree().get_nodes_in_group("Character").filter(
        func(checkCharacter: TowerDefenseCharacter) -> bool:
            if !checkCharacter.inGame:
                return false
            if checkCharacter.config.name == characterName:
                return true
            return false
    )
    return characterList

func GetProjectileHasTarget(projectile: TowerDefenseProjectile, checkLine: bool = false, fliterGraveStone: bool = true) -> bool:
    var characterList = get_tree().get_nodes_in_group("Character").filter(
        func(checkCharacter: TowerDefenseCharacter):
            if checkCharacter is TowerDefenseCrater:
                return false
            if checkCharacter is TowerDefenseItem:
                return false
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    return false

    )
    for checkCharacter: TowerDefenseCharacter in characterList:
        if projectile.CanTarget(checkCharacter) && checkCharacter.CanCollision(projectile.config.collisionFlags):
            if checkLine && !projectile.CheckSameLine(checkCharacter.gridPos.y):
                return false
            return true
    return false

func GetProjectileHasTargetFromArray(projectile: TowerDefenseProjectile, array: Array, checkLine: bool = false, fliterGraveStone: bool = true) -> bool:
    for checkCharacter: TowerDefenseCharacter in array:
        if projectile.CanTarget(checkCharacter) && checkCharacter.CanCollision(projectile.config.collisionFlags):
            if checkCharacter is TowerDefenseCrater:
                continue
            if checkCharacter is TowerDefenseItem:
                continue
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    continue

            if checkLine && !projectile.CheckSameLine(checkCharacter.gridPos.y):
                continue
            return true
    return false

func GetProjectileHasTargetFromArea(projectile: TowerDefenseProjectile, checkArea: Area2D, checkLine: bool = false, fliterGraveStone: bool = true) -> bool:
    var areas = checkArea.get_overlapping_areas()
    for area: Area2D in areas:
        var checkCharacter = area.get_parent()
        if checkCharacter is TowerDefenseCharacter:
            if checkCharacter.die || checkCharacter.nearDie:
                continue
            if projectile.CanTarget(checkCharacter) && checkCharacter.CanCollision(projectile.config.collisionFlags):
                if checkCharacter is TowerDefenseCrater:
                    continue
                if checkCharacter is TowerDefenseItem:
                    continue
                if fliterGraveStone:
                    if checkCharacter is TowerDefenseGravestone:
                        continue

                if checkLine && !projectile.CheckSameLine(checkCharacter.gridPos.y):
                    continue
                return true
    return false

func GetProjectileTarget(projectile: TowerDefenseProjectile, checkLine: bool = false, fliterGraveStone: bool = true) -> Array:
    var characterList = get_tree().get_nodes_in_group("Character").filter(
        func(checkCharacter: TowerDefenseCharacter) -> bool:
            if checkCharacter is TowerDefenseCrater:
                return false
            if checkCharacter is TowerDefenseItem:
                return false
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    return false

            if projectile.CanTarget(checkCharacter) && checkCharacter.CanCollision(projectile.config.collisionFlags):
                if checkLine && !projectile.CheckSameLine(checkCharacter.gridPos.y):
                    return false
                return true
            return false
    )
    return characterList

func GetProjectileTargetFromArray(projectile: TowerDefenseProjectile, array: Array, checkLine: bool = false, fliterGraveStone: bool = true) -> Array:
    var characterList = array.filter(
        func(checkCharacter: TowerDefenseCharacter) -> bool:
            if checkCharacter is TowerDefenseCrater:
                return false
            if checkCharacter is TowerDefenseItem:
                return false
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    return false

            if projectile.CanTarget(checkCharacter) && checkCharacter.CanCollision(projectile.config.collisionFlags):
                if checkLine && !projectile.CheckSameLine(checkCharacter.gridPos.y):
                    return false
                return true
            return false
    )
    return characterList

func GetProjectileTargetFromArea(projectile: TowerDefenseProjectile, checkArea: Area2D, checkLine: bool = false, fliterGraveStone: bool = true) -> Array:
    var characterList: Array = []
    var areas = checkArea.get_overlapping_areas()
    for area: Area2D in areas:
        var checkCharacter = area.get_parent()
        if checkCharacter is TowerDefenseCharacter:
            if checkCharacter.die || checkCharacter.nearDie:
                continue
            if checkCharacter is TowerDefenseCrater:
                continue
            if checkCharacter is TowerDefenseItem:
                continue
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    continue

            if projectile.CanTarget(checkCharacter) && projectile.CanCollision(checkCharacter.instance.maskFlags):
                if !checkLine || (checkLine && !projectile.CheckSameLine(checkCharacter.gridPos.y)):
                    characterList.append(checkCharacter)
    return characterList

func GetCharacterHasTarget(character: TowerDefenseCharacter, checkLine: bool = false, fliterGraveStone: bool = true) -> bool:
    var characterList = get_tree().get_nodes_in_group("Character")
    for checkCharacter: TowerDefenseCharacter in characterList:
        if character.CanTarget(checkCharacter) && character.CanCollision(checkCharacter.instance.maskFlags):
            if checkCharacter is TowerDefenseCrater:
                continue
            if checkCharacter is TowerDefenseItem:
                continue
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    continue

            if checkLine && !character.CheckSameLine(checkCharacter.gridPos.y):
                continue
            return true
    return false

func GetCharacterHasTargetFromArray(character: TowerDefenseCharacter, array: Array, checkLine: bool = false, fliterGraveStone: bool = true) -> bool:
    for checkCharacter: TowerDefenseCharacter in array:
        if character.CanTarget(checkCharacter) && character.CanCollision(checkCharacter.instance.maskFlags):
            if checkCharacter is TowerDefenseCrater:
                continue
            if checkCharacter is TowerDefenseItem:
                continue
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    continue

            if checkLine && !character.CheckSameLine(checkCharacter.gridPos.y):
                continue
            return true
    return false

func GetCharacterHasTargetFromArea(character: TowerDefenseCharacter, checkArea: Area2D, checkLine: bool = false, fliterGraveStone: bool = true) -> bool:
    var areas = checkArea.get_overlapping_areas()
    for area: Area2D in areas:
        var checkCharacter = area.get_parent()
        if checkCharacter is TowerDefenseCharacter:
            if checkCharacter.die || checkCharacter.nearDie:
                continue
            if checkCharacter is TowerDefenseCrater:
                continue
            if checkCharacter is TowerDefenseItem:
                continue
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    continue

            if character.CanTarget(checkCharacter) && character.CanCollision(checkCharacter.instance.maskFlags):
                if checkLine && !character.CheckSameLine(checkCharacter.gridPos.y):
                    continue
                return true
    return false

func GetCharacterTarget(character: TowerDefenseCharacter, checkLine: bool = false, checkCollision: bool = false, fliterGraveStone: bool = true) -> Array:
    var characterList = get_tree().get_nodes_in_group("Character").filter(
        func(checkCharacter: TowerDefenseCharacter):
            if character.CanTarget(checkCharacter):
                if checkCharacter is TowerDefenseCrater:
                    return false
                if checkCharacter is TowerDefenseItem:
                    return false
                if fliterGraveStone:
                    if checkCharacter is TowerDefenseGravestone:
                        return false

                if checkCollision && !character.CanCollision(checkCharacter.instance.maskFlags):
                    return false
                if checkLine && !character.CheckSameLine(checkCharacter.gridPos.y):
                    return false
                return true
            return false
    )
    return characterList

func GetCharacterTargetFromArray(character: TowerDefenseCharacter, array: Array, checkLine: bool = false, fliterGraveStone: bool = true) -> Array:
    var characterList = array.filter(
        func(checkCharacter: TowerDefenseCharacter):
            if character.CanTarget(checkCharacter) && character.CanCollision(checkCharacter.instance.maskFlags):
                if checkCharacter is TowerDefenseCrater:
                    return false
                if checkCharacter is TowerDefenseItem:
                    return false
                if fliterGraveStone:
                    if checkCharacter is TowerDefenseGravestone:
                        return false

                if checkLine && !character.CheckSameLine(checkCharacter.gridPos.y):
                    return false
                return true
            return false
    )
    return characterList

func GetCharacterTargetFromArea(character: TowerDefenseCharacter, checkArea: Area2D, checkLine: bool = false, fliterGraveStone: bool = true, fliterVase: bool = true) -> Array:
    var characterList: Array = []
    var areas = checkArea.get_overlapping_areas()
    for area: Area2D in areas:
        var checkCharacter = area.get_parent()
        if checkCharacter is TowerDefenseCharacter:
            if checkCharacter.die || checkCharacter.nearDie:
                continue
            if character.CanTarget(checkCharacter) && character.CanCollision(checkCharacter.instance.maskFlags):
                if checkCharacter is TowerDefenseCrater:
                    continue
                if checkCharacter is TowerDefenseItem:
                    if fliterVase:
                        continue
                    elif !checkCharacter is TowerDefenseVase:

                        continue
                if fliterGraveStone:
                    if checkCharacter is TowerDefenseGravestone:
                        continue
                if !checkLine || (checkLine && !character.CheckSameLine(checkCharacter.gridPos.y)):
                    characterList.append(checkCharacter)
    return characterList

func GetCharacterLine(line: int, fliterGraveStone: bool = true) -> Array:
    var characterList = get_tree().get_nodes_in_group("Character").filter(
        func(checkCharacter: TowerDefenseCharacter):
            if checkCharacter is TowerDefenseCrater:
                return false
            if checkCharacter is TowerDefenseItem:
                if checkCharacter.config.name != "ItemLadder":
                    return false
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    return false

            return checkCharacter.gridPos.y == line
    )
    return characterList

func GetCharacterTargetLine(character: TowerDefenseCharacter, fliterGraveStone: bool = true) -> Array:
    var characterList = get_tree().get_nodes_in_group("Character").filter(
        func(checkCharacter: TowerDefenseCharacter):
            if checkCharacter is TowerDefenseCrater:
                return false
            if checkCharacter is TowerDefenseItem:
                return false
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    return false

            if character.CanTarget(checkCharacter) && character.CanCollision(checkCharacter.instance.maskFlags):
                return checkCharacter.gridPos.y == character.gridPos.y
            return false
    )
    return characterList

func GetCharacterTargetLineFromArray(character: TowerDefenseCharacter, array: Array, fliterGraveStone: bool = true) -> Array:
    var characterList = array.filter(
        func(checkCharacter: TowerDefenseCharacter):
            if checkCharacter is TowerDefenseCrater:
                return false
            if checkCharacter is TowerDefenseItem:
                return false
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    return false

            if character.CanTarget(checkCharacter) && character.CanCollision(checkCharacter.instance.maskFlags):
                return checkCharacter.gridPos.y == character.gridPos.y
            return false
    )
    return characterList

func GetCharacterTargetLineFromArea(character: TowerDefenseCharacter, checkArea: Area2D, fliterGraveStone: bool = true) -> Array:
    var characterList: Array = []
    var areas = checkArea.get_overlapping_areas()
    for area: Area2D in areas:
        var checkCharacter = area.get_parent()
        if checkCharacter is TowerDefenseCharacter:
            if checkCharacter.die || checkCharacter.nearDie:
                continue
            if checkCharacter is TowerDefenseCrater:
                continue
            if checkCharacter is TowerDefenseItem:
                continue
            if fliterGraveStone:
                if checkCharacter is TowerDefenseGravestone:
                    continue

            if character.CanTarget(checkCharacter) && character.CanCollision(checkCharacter.instance.maskFlags):
                if checkCharacter.gridPos.y == character.gridPos.y:
                    characterList.append(checkCharacter)
    return characterList

func GetCharacterTargetNear(character: TowerDefenseCharacter, method: TowerDefenseEnum.TARGET_NEAR_METHOD = TowerDefenseEnum.TARGET_NEAR_METHOD.DEFAULT, checkLine: bool = false, fliterGravestone: bool = false) -> Array:
    var characterList = GetCharacterTarget(character, checkLine)
    match method:
        TowerDefenseEnum.TARGET_NEAR_METHOD.DEFAULT:
            characterList.sort_custom(
                func(a: TowerDefenseCharacter, b: TowerDefenseCharacter):
                    if fliterGravestone:
                        if a is TowerDefenseGravestone && b is not TowerDefenseGravestone:
                            return true
                        elif a is not TowerDefenseGravestone && b is TowerDefenseGravestone:
                            return false

                    return abs(a.global_position.x - character.global_position.x) < abs(b.global_position.x - character.global_position.x)
            )
        TowerDefenseEnum.TARGET_NEAR_METHOD.POSITION:
            characterList.sort_custom(
                func(a: TowerDefenseCharacter, b: TowerDefenseCharacter):
                    if fliterGravestone:
                        if a is TowerDefenseGravestone && b is not TowerDefenseGravestone:
                            return true
                        elif a is not TowerDefenseGravestone && b is TowerDefenseGravestone:
                            return false

                    return a.global_position.distance_to(character.global_position) < b.global_position.distance_to(character.global_position)
            )
    return characterList

func GetCharacterTargetNearFromArray(character: TowerDefenseCharacter, array: Array, method: TowerDefenseEnum.TARGET_NEAR_METHOD = TowerDefenseEnum.TARGET_NEAR_METHOD.DEFAULT, checkLine: bool = false, fliterGravestone: bool = false) -> Array:
    var characterList = GetCharacterTargetFromArray(character, array, checkLine, false)
    match method:
        TowerDefenseEnum.TARGET_NEAR_METHOD.DEFAULT:
            characterList.sort_custom(
                func(a: TowerDefenseCharacter, b: TowerDefenseCharacter):
                    if fliterGravestone:
                        if a is TowerDefenseGravestone && b is not TowerDefenseGravestone:
                            return false
                        elif a is not TowerDefenseGravestone && b is TowerDefenseGravestone:
                            return true

                    return abs(a.global_position.x - character.global_position.x) < abs(b.global_position.x - character.global_position.x)
            )
        TowerDefenseEnum.TARGET_NEAR_METHOD.POSITION:
            characterList.sort_custom(
                func(a: TowerDefenseCharacter, b: TowerDefenseCharacter):
                    if fliterGravestone:
                        if a is TowerDefenseGravestone && b is not TowerDefenseGravestone:
                            return false
                        elif a is not TowerDefenseGravestone && b is TowerDefenseGravestone:
                            return true

                    return a.global_position.distance_to(character.global_position) < b.global_position.distance_to(character.global_position)
            )
    return characterList

func GetCharacterTargetNearFromArea(character: TowerDefenseCharacter, checkArea: Area2D, method: TowerDefenseEnum.TARGET_NEAR_METHOD = TowerDefenseEnum.TARGET_NEAR_METHOD.DEFAULT, checkLine: bool = false, fliterGravestone: bool = false) -> Array:
    var characterList = GetCharacterTargetFromArea(character, checkArea, checkLine)
    match method:
        TowerDefenseEnum.TARGET_NEAR_METHOD.DEFAULT:
            characterList.sort_custom(
                func(a: TowerDefenseCharacter, b: TowerDefenseCharacter):
                    if fliterGravestone:
                        if a is TowerDefenseGravestone && b is not TowerDefenseGravestone:
                            return true
                        elif a is not TowerDefenseGravestone && b is TowerDefenseGravestone:
                            return false

                    return abs(a.global_position.x - character.global_position.x) < abs(b.global_position.x - character.global_position.x)
            )
        TowerDefenseEnum.TARGET_NEAR_METHOD.POSITION:
            characterList.sort_custom(
                func(a: TowerDefenseCharacter, b: TowerDefenseCharacter):
                    if fliterGravestone:
                        if a is TowerDefenseGravestone && b is not TowerDefenseGravestone:
                            return true
                        elif a is not TowerDefenseGravestone && b is TowerDefenseGravestone:
                            return false

                    return a.global_position.distance_to(character.global_position) < b.global_position.distance_to(character.global_position)
            )
    return characterList

func GetProjectileTargetNear(projectile: TowerDefenseProjectile, collisionFlags: int = -1, method: TowerDefenseEnum.TARGET_NEAR_METHOD = TowerDefenseEnum.TARGET_NEAR_METHOD.DEFAULT, checkLine: bool = false, fliterGravestone: bool = false) -> Array:
    var mapControl: TowerDefenseMapControl = TowerDefenseManager.GetMapControl()
    var characterList = get_tree().get_nodes_in_group("Character").filter(
        func(checkCharacter: TowerDefenseCharacter):
            if projectile.CanTarget(checkCharacter):
                if checkCharacter is TowerDefenseCrater:
                    return false
                if checkCharacter is TowerDefenseItem:
                    return false
                if fliterGravestone:
                    if checkCharacter is TowerDefenseGravestone:
                        return false
                if collisionFlags != -1:
                    if !(collisionFlags & checkCharacter.instance.maskFlags):
                        return false
                else:
                    if !projectile.CanCollision(checkCharacter.instance.maskFlags):
                        return false
                if checkLine && !projectile.CheckSameLine(checkCharacter.gridPos.y):
                    return false
                if checkCharacter.global_position.x > mapControl.config.edge.z:
                    return false
                return true
            return false
    )
    match method:
        TowerDefenseEnum.TARGET_NEAR_METHOD.DEFAULT:
            characterList.sort_custom(
                func(a: TowerDefenseCharacter, b: TowerDefenseCharacter):
                    if projectile.config.collisionFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE:
                        if !(a.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE) && (b.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE):
                            return false
                        elif (a.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE) && !(b.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE):
                            return true
                    if fliterGravestone:
                        if a is TowerDefenseGravestone && b is not TowerDefenseGravestone:
                            return true
                        elif a is not TowerDefenseGravestone && b is TowerDefenseGravestone:
                            return false

                    return abs(a.global_position.x - projectile.global_position.x) < abs(b.global_position.x - projectile.global_position.x)
            )
        TowerDefenseEnum.TARGET_NEAR_METHOD.POSITION:
            characterList.sort_custom(
                func(a: TowerDefenseCharacter, b: TowerDefenseCharacter):

                    if projectile.config.collisionFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE:
                        if !(a.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE) && (b.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE):
                            return false
                        elif (a.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE) && !(b.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE):
                            return true
                    if fliterGravestone:
                        if a is TowerDefenseGravestone && b is not TowerDefenseGravestone:
                            return true
                        elif a is not TowerDefenseGravestone && b is TowerDefenseGravestone:
                            return false

                    return a.global_position.distance_to(projectile.global_position) < b.global_position.distance_to(projectile.global_position)
            )
    return characterList

func GetProjectileTargetNearProjectile(projectile: TowerDefenseProjectile, collisionFlags: int = -1, method: TowerDefenseEnum.TARGET_NEAR_METHOD = TowerDefenseEnum.TARGET_NEAR_METHOD.DEFAULT, checkLine: bool = false, fliterGravestone: bool = true) -> Array:
    var mapControl: TowerDefenseMapControl = TowerDefenseManager.GetMapControl()
    var characterList = get_tree().get_nodes_in_group("Character").filter(
        func(checkCharacter: TowerDefenseCharacter):
            if projectile.CanTarget(checkCharacter):
                if checkCharacter is TowerDefenseCrater:
                    return false
                if checkCharacter is TowerDefenseItem:
                    return false
                if fliterGravestone:
                    if checkCharacter is TowerDefenseGravestone:
                        return false
                if is_instance_valid(checkCharacter.hitBox) && checkCharacter.hitBox.process_mode == ProcessMode.PROCESS_MODE_DISABLED:
                    return false
                if collisionFlags != -1:
                    if !(collisionFlags & checkCharacter.instance.maskFlags):
                        return false
                else:
                    if !projectile.CanCollision(checkCharacter.instance.maskFlags):
                        return false
                if checkLine && !projectile.CheckSameLine(checkCharacter.gridPos.y):
                    return false
                if checkCharacter.global_position.x > mapControl.config.edge.z:
                    return false
                return true
            return false
    )
    match method:
        TowerDefenseEnum.TARGET_NEAR_METHOD.DEFAULT:
            characterList.sort_custom(
                func(a: TowerDefenseCharacter, b: TowerDefenseCharacter):
                    if projectile.config.collisionFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE:
                        if !(a.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE) && (b.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE):
                            return false
                        elif (a.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE) && !(b.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE):
                            return true
                    if fliterGravestone:
                        if a is TowerDefenseGravestone && b is not TowerDefenseGravestone:
                            return true
                        elif a is not TowerDefenseGravestone && b is TowerDefenseGravestone:
                            return false

                    return abs(a.global_position.x - projectile.global_position.x) < abs(b.global_position.x - projectile.global_position.x)
            )
        TowerDefenseEnum.TARGET_NEAR_METHOD.POSITION:
            characterList.sort_custom(
                func(a: TowerDefenseCharacter, b: TowerDefenseCharacter):

                    if projectile.config.collisionFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE:
                        if !(a.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE) && (b.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE):
                            return false
                        elif (a.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE) && !(b.instance.maskFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE):
                            return true
                    if fliterGravestone:
                        if a is TowerDefenseGravestone && b is not TowerDefenseGravestone:
                            return true
                        elif a is not TowerDefenseGravestone && b is TowerDefenseGravestone:
                            return false

                    return a.global_position.distance_to(projectile.global_position) < b.global_position.distance_to(projectile.global_position)
            )
    return characterList





func ProtalCreate(shape: String = "Circle", posRange: Vector4 = Vector4.ZERO, changeTime: float = 0.0) -> TowerDefensePortal:
    var characterNode: Node2D = GetCharacterNode()
    var protal: TowerDefensePortal = TOWER_DEFENSE_PORTAL.instantiate() as TowerDefensePortal
    characterNode.add_child(protal)
    protal.Init(shape, posRange, changeTime)
    return protal

func ProtalChangePos() -> void :
    var protalList = get_tree().get_nodes_in_group("Portal")
    for protal: TowerDefensePortal in protalList:
        protal.ChangePos()
