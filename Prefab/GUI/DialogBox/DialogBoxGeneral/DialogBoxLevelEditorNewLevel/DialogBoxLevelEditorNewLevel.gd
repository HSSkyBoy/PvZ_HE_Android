extends DialogPopup

signal createLevel(level: TowerDefenseLevelConfig)

func NormalButtonPressed() -> void :
    var config = TowerDefenseLevelConfig.new()
    createLevel.emit(config)
    Close()

func ConveyorButtonPressed() -> void :
    var config = TowerDefenseLevelConfig.new()
    config.ConveyorPreset()
    createLevel.emit(config)
    Close()

func CancleButtonPressed() -> void :
    Close()
