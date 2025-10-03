@tool
extends TowerDefenseZombie

@onready var spotlight2: Sprite2D = %Spotlight2
@onready var spotlight: Sprite2D = %Spotlight
@export var spotlightGrandient: Gradient
var moonWalkOver: bool = false
var moonWalkMode: bool = false
var savePos: Vector2

var walkTime: int = 4
var danceTime: int = 2

var dancerList: Array[TowerDefenseCharacter] = []
var dancerPacketName: String = "ZombieBackup"

var firstSpawn: bool = false

func _ready() -> void :
    super ._ready()
    if Engine.is_editor_hint():
        return
    dancerList.resize(4)





func MoonWalkEntered() -> void :
    groundMoveComponent.alive = true
    sprite.SetAnimation("MoonWalk", true, 0.2)
    sprite.scale.x = -0.8
    if global_position.x < TowerDefenseManager.GetMapGroundRight():
        moonWalkMode = true
        savePos = global_position

@warning_ignore("unused_parameter")
func MoonWalkProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 1.0
    if moonWalkMode:
        if abs(global_position.x - savePos.x) > TowerDefenseManager.GetMapGridSize().x * 2.5:
            moonWalkOver = true
            state.send_event("ToPoint")
            return
    else:
        if global_position.x < TowerDefenseManager.GetMapGroundRight() - TowerDefenseManager.GetMapGridSize().x * 2.5:
            moonWalkOver = true
            state.send_event("ToPoint")
            return
    if attackComponent.CanAttack():
        moonWalkOver = true
        state.send_event("ToPoint")
        return

func MoonWalkExited() -> void :
    groundMoveComponent.alive = false
    sprite.scale.x = 0.8

func DanceEntered() -> void :
    danceTime = 2
    sprite.SetAnimation("ArmRise", true, 0.2)

@warning_ignore("unused_parameter")
func DanceProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 1.0
    if !sprite.pause && attackComponent.CanAttack():
        Attack()

func DanceExited() -> void :
    sprite.scale.x = 0.8

func PointEntered() -> void :

    sprite.SetAnimation("PointUp", false, 0.2)
    sprite.AddAnimation("PointDown", 0.75, false, 0.2)

@warning_ignore("unused_parameter")
func PointProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 0.75

func PointExited() -> void :
    pass

func WalkEntered() -> void :
    super .WalkEntered()
    sprite.scale.x = 0.8
    for dancer in dancerList:
        if is_instance_valid(dancer):
            dancer.timeScale = timeScale
            dancer.walkSpeedScale = walkSpeedScale
    walkTime = 4

func WalkProcessing(delta: float) -> void :
    groundMoveComponent.alive = CanWalk()
    super .WalkProcessing(delta)


func WalkExited() -> void :
    if !instance.die:
        groundMoveComponent.alive = false

func Walk() -> void :
    if !moonWalkOver:
        state.send_event("ToMoonWalk")
        return
    state.send_event("ToWalk")

func DieProcessing(delta: float) -> void :
    super .DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "PointDown":
            for dancer in dancerList:
                if is_instance_valid(dancer):
                    if !dancer.die && !dancer.nearDie:
                        dancer.Walk()
            Walk()
        "Walk":
            walkTime -= 1
            if ( !die && !nearDie):
                if walkTime <= 0:
                    if CanSpawnDancer():
                        state.send_event("ToPoint")
                        return
                    else:
                        for dancer in dancerList:
                            if is_instance_valid(dancer):
                                if !dancer.die && !dancer.nearDie:
                                    if dancer.sprite.clip == "Walk":
                                        dancer.state.send_event("ToDance")
                        state.send_event("ToDance")
                        return
            else:
                Die()
        "ArmRise":
            danceTime -= 1
            if ( !die && !nearDie):
                if danceTime <= 0:
                    if CanSpawnDancer():
                        state.send_event("ToPoint")
                        return
                    else:
                        for dancer in dancerList:
                            if is_instance_valid(dancer):
                                if !dancer.die && !dancer.nearDie:
                                    if dancer.sprite.clip == "ArmRise":
                                        dancer.Walk()
                        Walk()
                        return
            else:
                Die()

func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "spawn":
            if !die && !nearDie:
                SpawnDancer()
                spotlight.visible = true
                spotlight2.visible = true
                ChangeSpotlightColor()
                if !firstSpawn:
                    firstSpawn = true
                    AudioManager.AudioPlay("Dancer", AudioManagerEnum.TYPE.SFX)

func CanWalk() -> bool:
    if is_instance_valid(dancerList[0]):
        if dancerList[0].sprite.clip != "Walk":
            return false
    if is_instance_valid(dancerList[1]):
        if dancerList[1].sprite.clip != "Walk":
            return false
    if is_instance_valid(dancerList[2]):
        if dancerList[2].sprite.clip != "Walk":
            return false
    if is_instance_valid(dancerList[3]):
        if dancerList[3].sprite.clip != "Walk":
            return false
    return true

func CanSpawnDancer() -> bool:
    var gridNum: Vector2 = TowerDefenseManager.GetMapGridNum()
    if gridPos.y > 1:
        if !is_instance_valid(dancerList[0]):
            return true
    if gridPos.y < gridNum.y:
        if !is_instance_valid(dancerList[1]):
            return true
    if !is_instance_valid(dancerList[2]):
        return true
    if !is_instance_valid(dancerList[3]):
        return true
    return false

func SpawnDancer() -> void :
    var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(dancerPacketName)
    var gridNum: Vector2i = TowerDefenseManager.GetMapGridNum()
    var gridSize: Vector2 = TowerDefenseManager.GetMapGridSize()
    if gridPos.y > 1:
        if !is_instance_valid(dancerList[0]):
            var dancer = packetConfig.Create(Vector2(global_position.x, TowerDefenseManager.GetMapLineY(gridPos.y - 1)), gridPos - Vector2i(0, 1), 0)
            var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
            characterNode.add_child.call_deferred(dancer)
            dancer.set_deferred("instance:hitpointScale", instance.hitpointScale)
            dancer.set_deferred("transformPoint.scale", transformPoint.scale)
            dancer.Rise.call_deferred(1.5)
            dancer.jackson = self
            if instance.hypnoses:
                dancer.Hypnoses.call_deferred()
            dancerList[0] = dancer
    if gridPos.y < gridNum.y:
        if !is_instance_valid(dancerList[1]):
            var dancer = packetConfig.Create(Vector2(global_position.x, TowerDefenseManager.GetMapLineY(gridPos.y + 1)), gridPos + Vector2i(0, 1), 0)
            var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
            characterNode.add_child.call_deferred(dancer)
            dancer.set_deferred("instance:hitpointScale", instance.hitpointScale)
            dancer.set_deferred("transformPoint.scale", transformPoint.scale)

            dancer.Rise.call_deferred(1.5)
            dancer.jackson = self
            if instance.hypnoses:
                dancer.Hypnoses.call_deferred()
            dancerList[1] = dancer
    if !is_instance_valid(dancerList[2]):
        var dancer = packetConfig.Create(global_position - Vector2(gridSize.x * 1.25, 0), gridPos - Vector2i(1, 0), 0)
        var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
        characterNode.add_child.call_deferred(dancer)
        dancer.set_deferred("instance:hitpointScale", instance.hitpointScale)
        dancer.set_deferred("transformPoint.scale", transformPoint.scale)
        dancer.Rise.call_deferred(1.5)
        dancer.jackson = self
        if instance.hypnoses:
            dancer.Hypnoses.call_deferred()
        dancerList[2] = dancer
    if !is_instance_valid(dancerList[3]):
        var dancer = packetConfig.Create(global_position + Vector2(gridSize.x * 1.25, 0), gridPos + Vector2i(1, 0), 0)
        var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
        characterNode.add_child.call_deferred(dancer)
        dancer.set_deferred("instance:hitpointScale", instance.hitpointScale)
        dancer.set_deferred("transformPoint.scale", transformPoint.scale)
        dancer.Rise.call_deferred(1.5)
        dancer.jackson = self
        if instance.hypnoses:
            dancer.Hypnoses.call_deferred()
        dancerList[3] = dancer

func ChangeSpotlightColor() -> void :
    var color = spotlightGrandient.sample(randf())
    spotlight.modulate = color
    spotlight2.modulate = color
    get_tree().create_timer(3.0, false).timeout.connect(ChangeSpotlightColor)

func Hypnoses(time: float = -1) -> void :
    super .Hypnoses(time)
    for dancer in dancerList:
        if is_instance_valid(dancer):
            dancer.jackson = null
    dancerList.clear()
    dancerList.resize(4)
