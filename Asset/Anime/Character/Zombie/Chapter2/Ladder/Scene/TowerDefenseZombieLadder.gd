@tool
extends TowerDefenseZombie

var ladderOver: bool = false:
    set(_ladderOver):
        ladderOver = _ladderOver
        if ladderOver:
            walkAnimeClip = "Walk"
            attackAnimeClip = "Eat"
        else:
            walkAnimeClip = "LadderWalk"
            attackAnimeClip = "LadderEat"

func LadderEntered() -> void :
    sprite.SetAnimation("Ladder", false, 0.2)

@warning_ignore("unused_parameter")
func LadderProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * walkSpeedScale * 1.0

func LadderExited() -> void :
    pass

func AttackProcessing(delta: float) -> void :
    if !ladderOver:
        if !sprite.pause && attackComponent.CanAttack():
            if is_instance_valid(attackComponent.target):
                var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(attackComponent.target.gridPos)
                if is_instance_valid(cell) && cell.HasWallnut():
                    state.send_event("ToLadder")
                    return
    super.AttackProcessing(delta)
    if !ladderOver:
        sprite.timeScale = timeScale * 4.0

func WalkProcessing(delta: float) -> void :
    if !ladderOver:
        if !sprite.pause && attackComponent.CanAttack():
            if is_instance_valid(attackComponent.target):
                var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(attackComponent.target.gridPos)
                if is_instance_valid(cell) && cell.HasWallnut():
                    state.send_event("ToLadder")
                    return
    super.WalkProcessing(delta)
    if !ladderOver:
        sprite.timeScale = timeScale * 2.0

func ArmorHitpointsEmpty(armorName: String) -> void :
    super.ArmorHitpointsEmpty(armorName)
    match armorName:
        "Ladder":
            ladderOver = true
            Walk()

func AnimeEvent(command: String, argument: Variant) -> void :
    super.AnimeEvent(command, argument)
    match command:
        "place_ladder":
            LadderPlace()

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Ladder":
            Walk()

func LadderPlace() -> void :
    var ladderConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig("ItemLadder")
    if is_instance_valid(attackComponent.target):
        var cell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(attackComponent.target.gridPos)
        if is_instance_valid(cell) && cell.HasWallnut() && cell.CanPacketPlant(ladderConfig):
            ladderConfig.Plant(attackComponent.target.gridPos)
            ladderOver = true
            instance.ArmorDelete("Ladder", false)
            attackComponent.target = null
