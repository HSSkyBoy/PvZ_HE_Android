@tool
class_name TowerDefenseLevelWaveManagerConfig extends Resource

@export var flagZombie: String = "ZombieFlag"
@export var flagWaveInterval: int = 10
@export var maxNextWaveHealthPercentage: float = 0.15
@export var minNextWaveHealthPercentage: float = 0.2
@export var beginCol: float = 20.0
@export var spawnColEnd: float = 20.0
@export var spawnColStart: float = 5.0
@export var spawnOverride: TowerDefenseCharacterOverride
@export_category("Dynamic")
@export var dynamic: Array[TowerDefenseLevelDynamicConfig] = [null, null, null, null, null, null, null]:
    set(_dynamic):
        dynamic = _dynamic
        WaveDynamicPlantfoodFill()
@export_category("Wave")
@export var wave: Array[TowerDefenseLevelWaveConfig]:
    set(_wave):
        wave = _wave
        WaveDynamicPlantfoodFill()

func Init(waveManagerData: Dictionary) -> void :
    flagZombie = waveManagerData.get("FlagZombie", "ZombieFlag")
    flagWaveInterval = waveManagerData.get("FlagWaveInterval", 5.0)
    maxNextWaveHealthPercentage = waveManagerData.get("MaxNextWaveHealthPercentage", 0.15)
    minNextWaveHealthPercentage = waveManagerData.get("MinNextWaveHealthPercentage", 0.2)
    beginCol = waveManagerData.get("BeginCol", 20.0)
    spawnColEnd = waveManagerData.get("SpawnColEnd", 20.0)
    spawnColStart = waveManagerData.get("SpawnColStart", 5.0)
    if waveManagerData.has("SpawnOverride"):
        spawnOverride = TowerDefenseCharacterOverride.new()
        spawnOverride.Init(waveManagerData.get("SpawnOverride", {}))
    var dynamicList: Array = waveManagerData.get("Dynamic", {}) as Array
    for dynamicDictionary: Dictionary in dynamicList:
        var dynamicConfig: TowerDefenseLevelDynamicConfig = TowerDefenseLevelDynamicConfig.new()
        if !dynamicDictionary.is_empty():
            dynamicConfig.Init(dynamicDictionary)
        dynamic.append(dynamicConfig)
    var waveList: Array = waveManagerData.get("Wave", {}) as Array
    for waveDictionary: Dictionary in waveList:
        var waveConfig: TowerDefenseLevelWaveConfig = TowerDefenseLevelWaveConfig.new()
        waveConfig.Init(waveDictionary)
        wave.append(waveConfig)

func Export() -> Dictionary:
    var data: Dictionary = {
        "FlagZombie": flagZombie, 
        "FlagWaveInterval": flagWaveInterval, 
        "MaxNextWaveHealthPercentage": maxNextWaveHealthPercentage, 
        "MinNextWaveHealthPercentage": minNextWaveHealthPercentage, 
        "BeginCol": beginCol, 
        "SpawnColEnd": spawnColEnd, 
        "SpawnColStart": spawnColStart, 
        "Dynamic": [], 
        "Wave": []
    }
    if is_instance_valid(spawnOverride):
        data["SpawnOverride"] = spawnOverride.Export()
    for dynamicGet: TowerDefenseLevelDynamicConfig in dynamic:
        if is_instance_valid(dynamicGet):
            data["Dynamic"] = dynamicGet.Export()
        else:
            data["Dynamic"].append({})
    for waveGet: TowerDefenseLevelWaveConfig in wave:
        data["Wave"].append(waveGet.Export())
    return data

func WaveDynamicPlantfoodFill():
    for waveConfig: TowerDefenseLevelWaveConfig in wave:
        if waveConfig:
            waveConfig.dynamicPlantfood.resize(dynamic.size())
