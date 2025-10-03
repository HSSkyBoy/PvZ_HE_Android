@tool
extends TowerDefenseZombie

var timer: float = 0
var spawnNext: bool = false

var jumpMove: bool = false

func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    if Engine.is_editor_hint():
        return
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if !inGame:
        return
    if !spawnNext:
        if timer < 15.0:
            timer += delta * timeScale
        else:
            spawnNext = true
            timer = 0.0

func WalkEntered() -> void :
    if inWater:
        if !inSwimPlay && inSwimAnimeClip != "":
            sprite.SetAnimation(inSwimAnimeClip, false, 0.2)
            sprite.AddAnimation(swimAnimeClip, 0.0, true, 0.0)
            inSwimPlay = true
        else:
            sprite.SetAnimation(swimAnimeClip, true, 0.2)
        await get_tree().create_timer(0.1, false).timeout
        groundMoveComponent.alive = true
    else:
        if jumpMove:
            jumpMove = false
            if inWater:
                sprite.SetAnimation(swimAnimeClip, true, 0.0)
            else:
                sprite.SetAnimation(walkAnimeClip, true, 0.0)
            await get_tree().create_timer(0.1, false).timeout
            groundMoveComponent.alive = true
        else:
            super .WalkEntered()

func OutWater() -> void :
    super .OutWater()
    global_position.x -= scale.x * 20.0

func DieEntered() -> void :
    super .DieEntered()
    sprite.offset = Vector2(-50, -80)

func PointEntered() -> void :
    if inWater:
        sprite.SetAnimation("SwimPoint", false)
    else:
        sprite.SetAnimation("Point", false)

@warning_ignore("unused_parameter")
func PointProcessing(delta: float) -> void :
    sprite.timeScale = timeScale

func PointExited() -> void :
    pass

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    if !die && !nearDie:
        if spawnNext:
            state.send_event("ToPoint")
            spawnNext = false
            return
    match clip:
        "Point", "SwimPoint":
            Walk()
        "Jump":
            jumpMove = true
            global_position.x -= scale.x * 60.0

func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "attack":
            attackComponent.Attack(config.smashAttack)
        "spawn":
            SpawnSnorkle()

func SpawnSnorkle() -> void :
    var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig("ZombieSnorkleTanglekelp")
    var gridNum: Vector2i = TowerDefenseManager.GetMapGridNum()
    if gridPos.y > 1:
        var snorkle = packetConfig.Create(Vector2(global_position.x, TowerDefenseManager.GetMapLineY(gridPos.y - 1)), gridPos - Vector2i(0, 1), 0)
        var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
        characterNode.add_child.call_deferred(snorkle)
        snorkle.Rise.call_deferred(1.5)
        if instance.hypnoses:
            snorkle.Hypnoses.call_deferred()
    if gridPos.y < gridNum.y:
        var snorkle = packetConfig.Create(Vector2(global_position.x, TowerDefenseManager.GetMapLineY(gridPos.y + 1)), gridPos + Vector2i(0, 1), 0)
        var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
        characterNode.add_child.call_deferred(snorkle)
        snorkle.Rise.call_deferred(1.5)
        if instance.hypnoses:
            snorkle.Hypnoses.call_deferred()
    if true:
        var snorkle = packetConfig.Create(Vector2(global_position.x, TowerDefenseManager.GetMapLineY(gridPos.y)), gridPos, 0)
        var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
        characterNode.add_child.call_deferred(snorkle)
        snorkle.Rise.call_deferred(1.5)
        if instance.hypnoses:
            snorkle.Hypnoses.call_deferred()
