class_name TowerDefenseLevelEventGravestoneSpawnZombie extends TowerDefenseLevelEventBase

@export var zombieNames: Array = ["ZombieNormal", "ZombieNormalCone", "ZombieNormalBucket"]
@export var zombieNum: int = 5
@export var delay: Vector2 = Vector2(-1, -1)
@export var override: TowerDefenseCharacterOverride

func GetName() -> String:
    return "LEVLE_EVENT_GRAVESTONE_SPAWN_ZOMBIE"

func Execute() -> void :
    var weightPick: Array[WeightPickItemBase] = []
    if zombieNames.size() > 0:
        for zombieName: String in zombieNames:
            var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(zombieName)
            var characterConfig: TowerDefenseCharacterConfig = packetConfig.characterConfig
            if characterConfig is TowerDefenseZombieConfig:
                var weight: int = characterConfig.weight
                if packetConfig.overrideWeight != -1:
                    weight = packetConfig.overrideWeight
                var weightPickItem: WeightPickItemBase = WeightPickItemBase.new(zombieName, weight)
                weightPick.append(weightPickItem)
        var cansSpawnPos: Array[Vector2i] = []
        var gravestoneList = Global.get_tree().get_nodes_in_group("Gravestone")
        for gravestone in gravestoneList:
            if gravestone is TowerDefenseGravestone:
                cansSpawnPos.append(gravestone.gridPos)
        var num: int = min(cansSpawnPos.size(), zombieNum)
        while (num > 0):
            TowerDefenseManager.currentControl.get_tree().create_timer(randf_range(delay.x, delay.y), false).timeout.connect(
                func():
                    var checkGravestoneList = Global.get_tree().get_nodes_in_group("Gravestone")
                    var checkPos: Array[Vector2i] = []
                    for gravestone in checkGravestoneList:
                        if gravestone is TowerDefenseGravestone:
                            checkPos.append(gravestone.gridPos)
                    var item: WeightPickItemBase = WeightPickMathine.Pick(weightPick)
                    var packet: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(item.item)
                    var gridPos: Vector2i = cansSpawnPos.pick_random()
                    if checkPos.has(gridPos):
                        var zombie: TowerDefenseZombie = packet.Plant(gridPos, false) as TowerDefenseZombie
                        zombie.Rise(randf_range(0.75, 1.25))
                        if override:
                            override.ExecuteCharacter(zombie)
                        TowerDefenseInGameWaveManager.instance.AddSpawnCharacter(zombie)
                    cansSpawnPos.erase(gridPos)
            )
            num -= 1

func Init(valueDictionary: Dictionary) -> void :
    zombieNames = valueDictionary.get("ZombieNames", [])
    zombieNum = valueDictionary.get("ZombieNum", 1)
    var delayGet = valueDictionary.get("Delay", [-1, -1])
    if delayGet is Array:
        if delayGet.size() == 2:
            delay = Vector2(delayGet[0], delayGet[1])
        elif delayGet.size() == 1:
            delay = Vector2(delayGet[0], delayGet[0])
    if delayGet is float:
        delay = Vector2.ONE * delayGet

    var overrideData = valueDictionary.get("Override", {}) as Dictionary
    if !overrideData.is_empty():
        override = TowerDefenseCharacterOverride.new()
        override.Init(overrideData)

func Export() -> Dictionary:
    var data = {
        "EventName": "GravestoneSpawnZombie", 
        "Value": {
            "ZombieNames": zombieNames, 
            "ZombieNum": zombieNum, 
            "Delay": [delay.x, delay.y], 
        }
    }
    if is_instance_valid(override):
        data["Value"]["Override"] = override.Export()
    return data

func GetProperty() -> Dictionary:
    var data = super .GetProperty()
    data["随机创建墓碑僵尸"] = {
        "数量": {
            "Object": self, 
            "Type": "Int", 
            "Property": "zombieNum", 
            "Rest": 5
        }, 
        "延时范围": {
            "Object": self, 
            "Type": "Vector2", 
            "Property": "delay", 
            "Rest": Vector2(-1, -1)
        }
    }
    return data
