class_name TowerDefenseInGameVaseManager extends Control

var config: TowerDefenseLevelVaseManagerConfig

func Init(_config: TowerDefenseLevelVaseManagerConfig) -> void :
    config = _config
    if !config.shuffle:
        for vaseConfig: TowerDefenseLevelVaseConfig in config.vaseList:
            var vasePacketConfig: TowerDefensePacketConfig
            match vaseConfig.type:
                "Plant":
                    vasePacketConfig = TowerDefenseManager.GetPacketConfig("VasePlant")
                "Zombie":
                    vasePacketConfig = TowerDefenseManager.GetPacketConfig("VaseZombie")
                _:
                    vasePacketConfig = TowerDefenseManager.GetPacketConfig("VaseNormal")
            var vase = vasePacketConfig.Plant(vaseConfig.gridPos)
            if vaseConfig.packetName != "":
                vase.packetConfig = vaseConfig.GetPacket()
            else:
                if config.vaseFillList.size() > 0:
                    var packetConfig = config.vaseFillList.pick_random().GetPacket()
                    while (true):
                        if vaseConfig.type != "Plant" && vaseConfig.type != "Zombieal":
                            break
                        if vaseConfig.type == "Plant" && packetConfig.characterConfig is TowerDefensePlantConfig:
                            break
                        if vaseConfig.type == "Zombie" && packetConfig.characterConfig is TowerDefenseZombieConfig:
                            break
                        packetConfig = config.vaseFillList.pick_random().GetPacket()
                    vase.packetConfig = packetConfig
    else:
        var posList: Array[Vector2i] = []
        var typeList: Array[String] = []
        var packetConfigList: Array[TowerDefensePacketConfig]
        for vaseConfig: TowerDefenseLevelVaseConfig in config.vaseList:
            posList.append(vaseConfig.gridPos)
            typeList.append(vaseConfig.type)
            if vaseConfig.packetName == "":
                if config.vaseFillList.size() > 0:
                    packetConfigList.append(config.vaseFillList.pick_random().GetPacket())
                else:
                    packetConfigList.append(null)
            else:
                packetConfigList.append(vaseConfig.GetPacket())
        posList.shuffle()
        typeList.shuffle()
        packetConfigList.shuffle()
        for packetConfig: TowerDefensePacketConfig in packetConfigList:
            var pos: Vector2 = posList.pop_back()
            var type: String = "Normal"
            if is_instance_valid(packetConfig):
                if packetConfig.characterConfig is TowerDefensePlantConfig:
                    if typeList.has("Plant"):
                        type = "Plant"
                        typeList.erase("Plant")
                elif packetConfig.characterConfig is TowerDefenseZombieConfig:
                    if typeList.has("Zombie"):
                        type = "Zombie"
                        typeList.erase("Zombie")
                else:
                    type = typeList.pop_back()
            else:
                type = typeList.pop_back()
            var vasePacketConfig
            match type:
                "Plant":
                    vasePacketConfig = TowerDefenseManager.GetPacketConfig("VasePlant")
                "Zombie":
                    vasePacketConfig = TowerDefenseManager.GetPacketConfig("VaseZombie")
                _:
                    vasePacketConfig = TowerDefenseManager.GetPacketConfig("VaseNormal")
            var vase = vasePacketConfig.Plant(pos)
            vase.packetConfig = packetConfig
