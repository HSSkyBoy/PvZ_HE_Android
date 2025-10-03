class_name TowerDefenseLevelVaseManagerConfig extends Resource

@export var shuffle: bool = true
@export var vaseList: Array[TowerDefenseLevelVaseConfig]
@export var vaseFillList: Array[TowerDefenseLevelVaseFillConfig]

func Init(data: Dictionary) -> void :
    vaseList.clear()
    vaseFillList.clear()

    shuffle = data.get("Shuffle", false)

    var vaseListGet = data.get("Vase", [])
    for vaseData: Dictionary in vaseListGet:
        var vaseConfig: TowerDefenseLevelVaseConfig = TowerDefenseLevelVaseConfig.new()
        vaseConfig.Init(vaseData)
        vaseList.append(vaseConfig)

    var vaseFillListGet = data.get("VaseFill", [])
    for vaseFillData: Dictionary in vaseFillListGet:
        var vaseFillConfig: TowerDefenseLevelVaseFillConfig = TowerDefenseLevelVaseFillConfig.new()
        vaseFillConfig.Init(vaseFillData)
        vaseFillList.append(vaseFillConfig)

func Export() -> Dictionary:
    var data: Dictionary = {
        "Shuffle": shuffle, 
        "Vase": [], 
        "VaseFill": []
    }
    for vase: TowerDefenseLevelVaseConfig in vaseList:
        data["Vase"].append(vase.Export())
    for vaseFill: TowerDefenseLevelVaseFillConfig in vaseFillList:
        data["VaseFill"].append(vaseFill.Export())
    return data
