class_name LevelDifficultSlider extends HSlider

var levelConfig: TowerDefenseLevelConfig

func Init(_levelConfig: TowerDefenseLevelConfig):
    levelConfig = _levelConfig
    if !levelConfig:
        return
    var waveManager: TowerDefenseLevelWaveManagerConfig = levelConfig.waveManager
    max_value = waveManager.dynamic.size() - 1
    tick_count = 3
    value = TowerDefenseManager.currentDynamicLevel

func DragEnd(isChanged: bool) -> void :
    if isChanged:
        value = round(value)
