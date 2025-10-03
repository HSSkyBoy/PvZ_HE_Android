class_name TowerDefenseInGameWaveManager extends Control

@onready var levelNameLabel: Label = %LevelNameLabel
@onready var difficultLabel: Label = %DifficultLabel

@onready var progressMeter: GeneralProgressMeter = %GeneralProgressMeter

signal waveReady()
signal waveBegin(id: int, isBigWave: bool, isFinalWave: bool)
signal bigWaveBegin(bigWaveId: int)
signal final()

static  var instance: TowerDefenseInGameWaveManager = null

var isRunning: bool = false
var timer: float = 0.9

var nextWaveTime: float = 0.0

var waveStart: bool = false
var waveFinal: bool = false
var awardTime: bool = false
var awardPos: Vector2 = Vector2.ZERO

var showCharacter: Array[TowerDefenseCharacter] = []

var currentWave: int = 0
var currentCharacter: Array[TowerDefenseCharacter]
var currentHpPointTotal: float = 0.0
var currentHpPoint: float = 0.0
var awaitSpawn: bool = false

var currentDynamic: TowerDefenseLevelDynamicConfig

var currentSpawnPoint: int = 0

var savePitchforkLine: int = -1

var config: TowerDefenseLevelWaveManagerConfig

var checkTime: float = 0.5

func Init(_config: TowerDefenseLevelWaveManagerConfig) -> void :
    config = _config
    if config.dynamic[TowerDefenseManager.currentDynamicLevel]:
        currentDynamic = config.dynamic[TowerDefenseManager.currentDynamicLevel]
    else:
        currentDynamic = TowerDefenseLevelDynamicConfig.new()
    progressMeter.Init(config.wave.size(), config.flagWaveInterval)

func _ready() -> void :
    instance = self
    var difficult: String = GameSaveManager.GetKeyValue("CurrentDifficult")
    var difiicultString: String = ""
    match difficult:
        "Normal":
            difiicultString = "正常"
            difficultLabel.modulate.g = 255.0 / 2.0
        "Difficult":
            difiicultString = "困难"
            difficultLabel.modulate.g = 0.0
        "Ultimate":
            difiicultString = "极限"
            difficultLabel.modulate.g = 0.0
    var text = tr(TowerDefenseManager.currentLevelConfig.levelName).replace("{LevelNumber}", str(TowerDefenseManager.currentLevelConfig.levelNumber))
    levelNameLabel.text = text
    difficultLabel.text = tr("INGAME_DIFFICULT") %[difiicultString]

func _physics_process(delta: float) -> void :
    if isRunning && !awaitSpawn && !waveFinal:
        var flagNextWave: bool = false
        var percentage: float = 1.0
        if waveStart && currentHpPointTotal != 0:
            percentage = currentHpPoint / currentHpPointTotal
        if timer < nextWaveTime:
            timer += delta
            if percentage < config.maxNextWaveHealthPercentage:
                if timer > config.spawnColStart:
                    flagNextWave = true
            if percentage < config.minNextWaveHealthPercentage:
                flagNextWave = true
        else:
            flagNextWave = true

        if flagNextWave:
            timer = 0.0
            awaitSpawn = true
            NextWave()

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
    if CommandManager.debug && Input.is_action_just_pressed("DebugWaveNext"):
        NextWave()

func StartWave() -> void :
    waveReady.emit()
    currentWave = 0
    isRunning = true
    waveStart = false
    currentSpawnPoint = currentDynamic.startingPoints
    nextWaveTime = config.beginCol

func NextWave() -> void :
    if !waveStart:
        AudioManager.AudioPlay("WaveBegin", AudioManagerEnum.TYPE.SFX)
        progressMeter.visible = true
        waveStart = true
        bigWaveBegin.emit(0)
    if (currentWave + 1) %config.flagWaveInterval == 0:
        AudioManager.AudioPlay("WaveHuge", AudioManagerEnum.TYPE.SFX)
        TowerDefenseManager.TipsPlay("TOWERDEFENSE_TIPS_HUGEWAVE", 4.0)
        await get_tree().create_timer(4.0, false).timeout
        AudioManager.AudioPlay("WaveHugeBegin", AudioManagerEnum.TYPE.SFX)

    var flagDynamic: bool = false
    if (currentWave + 1) >= currentDynamic.startingWave:
        currentSpawnPoint += currentDynamic.pointIncrementPerWave
        flagDynamic = true
    if currentWave < config.wave.size():
        Spawn(currentWave, flagDynamic)
        currentWave += 1
    nextWaveTime = config.spawnColEnd
    awaitSpawn = false
    if currentWave == 1:
        nextWaveTime *= 2.0
    if currentWave == 2:
        nextWaveTime *= 1.5
    if currentWave % config.flagWaveInterval == 0:
        nextWaveTime += 5.0
    if currentWave == config.wave.size():
        waveFinal = true
        final.emit()
        AudioManager.AudioPlay("WaveFinal", AudioManagerEnum.TYPE.SFX)
        TowerDefenseManager.TipsPlay("TOWERDEFENSE_TIPS_FINALWAVE", 2.0)

func AddSpawnCharacter(character) -> void :
    var hp: float = character.GetTotalHitPoint()
    currentHpPointTotal += hp
    currentHpPoint += hp
    character.bodyHurt.connect(HpPointDecrease)
    character.armmorHurt.connect(HpPointDecrease)
    character.destroy.connect(CharacterDestroy)
    currentCharacter.append(character)

func Spawn(waveId: int, dynamic: bool = false) -> void :
    var wave: TowerDefenseLevelWaveConfig = config.wave[waveId]
    for event: TowerDefenseLevelEventBase in wave.event:
        event.Execute()

    var flag: bool = false
    for lineId in TowerDefenseManager.GetMapGridNum().y:
        if TowerDefenseManager.GetMapLineUse(lineId + 1):
            flag = true
            break
    if !flag:
        return

    progressMeter.SetWaveCurrent(waveId + 1)
    var isHugeWave: bool = (waveId + 1) %config.flagWaveInterval == 0
    var isFinalWave: bool = waveId + 1 == config.wave.size()
    waveBegin.emit(waveId + 1, isHugeWave, isFinalWave)
    if isHugeWave:
        bigWaveBegin.emit(int(float(waveId + 1) / config.flagWaveInterval))
    for character: TowerDefenseCharacter in currentCharacter:
        if !character:
            character = null
        if character:
            character.bodyHurt.disconnect(HpPointDecrease)
            character.armmorHurt.disconnect(HpPointDecrease)
            character.destroy.disconnect(CharacterDestroy)
    currentCharacter.clear()
    currentHpPointTotal = 0

    var spawnPoint: int = currentSpawnPoint
    var spawnPointMin: int = 100000000
    var spawnList: Array = []
    spawnList.resize(26)
    if wave.dynamic:
        spawnPoint += wave.dynamic.points
    for spawnLine: int in TowerDefenseManager.GetMapGridNum().y:
        spawnList[spawnLine + 1] = []

    if isHugeWave && config.flagZombie != "":
        var spawnLinePick: int = 1 + randi() %TowerDefenseManager.GetMapGridNum().y
        var minNum: int = 10000
        var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(config.flagZombie)
        var checkList: Array = []
        for lineId in TowerDefenseManager.GetMapGridNum().y:
            if TowerDefenseManager.GetMapLineUse(lineId + 1):
                minNum = min(minNum, spawnList[lineId + 1].size())
        for lineId in TowerDefenseManager.GetMapGridNum().y:
            checkList.append(lineId + 1)
        spawnLinePick = checkList.pick_random()
        checkList.erase(spawnLinePick)
        while (checkList.size() > 0 && ( !TowerDefenseManager.GetMapLineUse(spawnLinePick)\
|| (minNum != spawnList[spawnLinePick].size() && !packetConfig.HasSpawnLimit())\
|| !packetConfig.CanSpawn(spawnLinePick))):
            spawnLinePick = checkList.pick_random()
            checkList.erase(spawnLinePick)
        var spawn: TowerDefenseLevelSpawnConfig = TowerDefenseLevelSpawnConfig.new()
        spawn.zombie = config.flagZombie
        spawnList[spawnLinePick].append(spawn)
    wave.spawn.shuffle()
    for spawn: TowerDefenseLevelSpawnConfig in wave.spawn:
        for i in spawn.num:
            if savePitchforkLine != -1:
                spawnList[savePitchforkLine].append(spawn)
                savePitchforkLine = -1
            elif spawn.line != -1:
                spawnList[spawn.line].append(spawn)
            else:
                var spawnLinePick: int = 1 + randi() %TowerDefenseManager.GetMapGridNum().y
                var minNum: int = 10000
                var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(spawn.zombie)
                var checkList: Array = []
                for lineId in TowerDefenseManager.GetMapGridNum().y:
                    if TowerDefenseManager.GetMapLineUse(lineId + 1):
                        minNum = min(minNum, spawnList[lineId + 1].size())
                    checkList.append(lineId + 1)
                spawnLinePick = checkList.pick_random()
                checkList.erase(spawnLinePick)
                while (checkList.size() > 0 && ( !TowerDefenseManager.GetMapLineUse(spawnLinePick)\
|| (minNum != spawnList[spawnLinePick].size() && !packetConfig.HasSpawnLimit())\
|| !packetConfig.CanSpawn(spawnLinePick))):
                    spawnLinePick = checkList.pick_random()
                    checkList.erase(spawnLinePick)
                spawnList[spawnLinePick].append(spawn)

    if dynamic || wave.dynamic:
        var weightPick: Array[WeightPickItemBase] = []
        var zombiePool: Array[String] = currentDynamic.zombiePool.duplicate(true)
        if wave.dynamic:
            zombiePool.append_array(wave.dynamic.zombiePool.duplicate(true))
        if zombiePool.size() > 0:
            for zombieName: String in zombiePool:
                var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(zombieName)
                var characterConfig: TowerDefenseCharacterConfig = packetConfig.characterConfig
                var spawn: TowerDefenseLevelSpawnConfig = TowerDefenseLevelSpawnConfig.new()
                spawn.zombie = zombieName
                if characterConfig is TowerDefenseZombieConfig:
                    var weight: int = packetConfig.GetWeight()
                    var weightPickItem: WeightPickItemBase = WeightPickItemBase.new(spawn, weight)
                    spawnPointMin = min(spawnPointMin, packetConfig.GetWavePointCost())
                    weightPick.append(weightPickItem)
            if spawnPoint > 0:
                while (spawnPoint >= spawnPointMin):
                    var item: WeightPickItemBase = WeightPickMathine.Pick(weightPick)
                    var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(item.item.zombie)
                    var characterConfig: TowerDefenseCharacterConfig = packetConfig.characterConfig
                    var pointCost: int = item.weight
                    if characterConfig is TowerDefenseZombieConfig:
                        pointCost = packetConfig.GetWavePointCost()
                    if spawnPoint < pointCost:
                        continue
                    spawnPoint -= pointCost
                    var spawnLinePick: int = 1 + randi() %TowerDefenseManager.GetMapGridNum().y
                    var minNum: int = 10000
                    var checkList: Array = []
                    for lineId in TowerDefenseManager.GetMapGridNum().y:
                        if TowerDefenseManager.GetMapLineUse(lineId + 1):
                            minNum = min(minNum, spawnList[lineId + 1].size())
                        checkList.append(lineId + 1)
                    spawnLinePick = checkList.pick_random()
                    checkList.erase(spawnLinePick)
                    while (checkList.size() > 0 && ( !TowerDefenseManager.GetMapLineUse(spawnLinePick)\
|| (minNum != spawnList[spawnLinePick].size() && !packetConfig.HasSpawnLimit())\
|| !packetConfig.CanSpawn(spawnLinePick))):
                        spawnLinePick = checkList.pick_random()
                        checkList.erase(spawnLinePick)
                    spawnList[spawnLinePick].append(item.item)
            else:
                spawnPoint = - spawnPoint
                while (spawnPoint >= spawnPointMin):
                    var item: WeightPickItemBase = WeightPickMathine.Pick(weightPick)
                    var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(item.item.zombie)
                    var characterConfig: TowerDefenseCharacterConfig = packetConfig.characterConfig
                    var pointCost: int = item.weight
                    if characterConfig is TowerDefenseZombieConfig:
                        pointCost = packetConfig.GetWavePointCost()
                    if spawnPoint < pointCost:
                        continue
                    var hasFlag: bool = false
                    for lineId in TowerDefenseManager.GetMapGridNum().y:
                        if TowerDefenseManager.GetMapLineUse(lineId + 1):
                            var spawnLineListCheck: Array = spawnList[lineId + 1]
                            for spawn: TowerDefenseLevelSpawnConfig in spawnLineListCheck:
                                if spawn.zombie == item.item && spawn.spawnEvent.size() <= 0 && spawn.dieEvent.size() <= 0:
                                    hasFlag = true
                                    break
                            if hasFlag:
                                break
                    if !hasFlag:
                        continue
                    spawnPoint -= pointCost

                    var spawnLinePick: int = 1 + randi() %TowerDefenseManager.GetMapGridNum().y
                    var spawnLineList: Array = spawnList[spawnLinePick]
                    while ( !TowerDefenseManager.GetMapLineUse(spawnLinePick)):
                        var checkHasFlag: bool = false
                        for spawn: TowerDefenseLevelSpawnConfig in spawnLineList:
                            if spawn.zombie == item.item && spawn.spawnEvent.size() <= 0 && spawn.dieEvent.size() <= 0:
                                checkHasFlag = true
                                break
                        if checkHasFlag:
                            break
                        spawnLinePick = 1 + randi() %TowerDefenseManager.GetMapGridNum().y
                        spawnLineList = spawnList[spawnLinePick]
                    for spawn: TowerDefenseLevelSpawnConfig in spawnLineList:
                        if spawn.zombie == item.item && spawn.spawnEvent.size() <= 0 && spawn.dieEvent.size() <= 0:
                            spawnList[spawnLinePick].erase(spawn)
                            break

    for spawnLine: int in TowerDefenseManager.GetMapGridNum().y:
        var spawnLineList: Array = spawnList[spawnLine + 1]
        spawnLineList.shuffle()
        for spawnNameId: int in spawnLineList.size():
            var spawn: TowerDefenseLevelSpawnConfig = spawnLineList[spawnNameId]
            var spawnName: String = spawn.zombie
            if spawnName == "":
                continue
            var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(spawnName)
            var character: TowerDefenseCharacter = packetConfig.Spawn(spawnLine + 1, spawnNameId * 60.0 + randf() * 60.0)
            if is_instance_valid(config.spawnOverride):
                config.spawnOverride.ExecuteCharacter(character)
            if is_instance_valid(spawn.override):
                spawn.override.ExecuteCharacter(character)
            for event: TowerDefenseCharacterEventBase in spawn.spawnEvent:
                event.Execute(character.global_position, character)
            character.dieEvent.append_array(spawn.dieEvent)

            currentHpPointTotal += character.GetTotalHitPoint()
            character.bodyHurt.connect(HpPointDecrease)
            character.armmorHurt.connect(HpPointDecrease)
            character.destroy.connect(CharacterDestroy)
            currentCharacter.append(character)

    currentHpPoint = currentHpPointTotal

func HpPointDecrease(num: int) -> void :
    currentHpPoint -= num

func CharacterDestroy(character: TowerDefenseCharacter) -> void :
    currentHpPoint -= character.GetTotalHitPoint()
    currentCharacter.erase(character)

func ShowCharacter() -> void :
    var currentdynamic: TowerDefenseLevelDynamicConfig = config.dynamic[TowerDefenseManager.currentDynamicLevel]

    var showCharacterList: Array[String] = []
    var showCharacterNumDictionary: Dictionary = {}
    var posList: Array[Vector2i] = []
    var dynamicList: Array[String] = []
    if currentdynamic:
        dynamicList.append_array(currentdynamic.zombiePool)

    for wave: TowerDefenseLevelWaveConfig in config.wave:
        for spawn: TowerDefenseLevelSpawnConfig in wave.spawn:
            var charcterName: String = spawn.zombie
            if !showCharacterList.has(charcterName):
                showCharacterList.append(charcterName)
                showCharacterNumDictionary[charcterName] = 0
            showCharacterNumDictionary[charcterName] += 1
        dynamicList.append_array(wave.dynamic.zombiePool)

    for charcterName: String in dynamicList:
        if !showCharacterList.has(charcterName):
            showCharacterList.append(charcterName)
            showCharacterNumDictionary[charcterName] = 0
        showCharacterNumDictionary[charcterName] += 1

    for characterName: String in showCharacterList:
        var pos: Vector2i = Vector2i(randi_range(0, 3), randi_range(1, TowerDefenseManager.GetMapGridNum().y))
        while posList.has(pos):
            pos = Vector2i(randi_range(0, 3), randi_range(1, TowerDefenseManager.GetMapGridNum().y))
        var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(characterName)
        var spawnPosX: float = pos.x * 60
        if pos.y % 2 == 0:
            spawnPosX -= 30
        var character: TowerDefenseCharacter = packetConfig.Spawn(pos.y, spawnPosX, true)
        character.gridPos = Vector2i(-1, -1)
        showCharacter.append(character)
        posList.append(pos)
        if posList.size() >= 4 * TowerDefenseManager.GetMapGridNum().y:
            break

    if showCharacterList.size() > 0 && showCharacterList.size() < 8:
        var weightPick: Array[WeightPickItemBase] = []
        for characterName: String in showCharacterList:
            var weightItem: WeightPickItemBase = WeightPickItemBase.new(characterName, showCharacterNumDictionary[characterName])
            weightPick.append(weightItem)
        for id in 8 - showCharacterList.size():
            var characterName: String = WeightPickMathine.Pick(weightPick).item
            var pos: Vector2i = Vector2i(randi_range(0, 3), randi_range(1, TowerDefenseManager.GetMapGridNum().y))
            while posList.has(pos):
                pos = Vector2i(randi_range(0, 3), randi_range(1, TowerDefenseManager.GetMapGridNum().y))
            var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(characterName)
            var spawnPosX: float = pos.x * 60
            if pos.y % 2 == 0:
                spawnPosX -= 30
            var character: TowerDefenseCharacter = packetConfig.Spawn(pos.y, spawnPosX, true)
            character.gridPos = Vector2i(-1, -1)
            showCharacter.append(character)
            posList.append(pos)

func ClearShowCharacter() -> void :
    for character: TowerDefenseCharacter in showCharacter:
        if is_instance_valid(character):
            character.queue_free()
