@tool
extends TowerDefensePlant

const IMITATER_CLOUD = preload("uid://djvfnrjg7vtqn")

@export var packetBank: String

var over: bool = false

func IdleEntered() -> void :
    super .IdleEntered()
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if !inGame:
        return
    instance.invincible = true
    sprite.SetAnimation("Open", false)

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func IdleExited() -> void :
    super .IdleExited()

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Open":
            if over:
                return
            over = true
            var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(IMITATER_CLOUD, gridPos)
            var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
            effect.global_position = global_position
            characterNode.add_child(effect)

            var packetBankData: TowerDefensePacketBankData = TowerDefenseManager.GetPacketBankData(packetBank)
            if is_instance_valid(packetBankData):
                var plantList: Array = packetBankData.GetPlantList()
                var plantRandom: String = plantList.pick_random()
                var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(plantRandom)
                while !cell.CanPacketPlant(packetConfig) && plantList.size() > 1:
                    plantList.erase(plantRandom)
                    plantRandom = plantList.pick_random()
                    packetConfig = TowerDefenseManager.GetPacketConfig(plantRandom)
                if plantList.size() > 1:
                    var plant = packetConfig.Plant(gridPos, true)
                    plant.instance.wakeUp = true
                    if instance.hypnoses:
                        plant.Hypnoses()
            Destroy()
