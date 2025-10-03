@tool
extends TowerDefenseZombie

var over: bool = false

func _ready() -> void :
    super._ready()
    if Engine.is_editor_hint():
        return

    if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
        sprite.SetFliters(["Zombie_duckytube", "Zombie_whitewater", "Zombie_whitewater2"], true)

func DieProcessing(delta: float) -> void :
    super.DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func DestroySet() -> void :
    if over:
        return
    over = true
    SpawnDuckytube()

func SpawnDuckytube() -> void :
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig("Duckytube")
    var duckytube = packetConfig.Create(global_position, gridPos)
    characterNode.add_child(duckytube)
