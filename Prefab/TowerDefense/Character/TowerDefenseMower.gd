@tool
class_name TowerDefenseMower extends TowerDefenseItem

const MOWER_HIT: PackedScene = preload("res://Prefab/TowerDefense/Mower/MowerHit.tscn")
const MOWER_PUFF = preload("uid://cv2sh3upqkd27")

@export var runAnimeClips: String = "Normal"
@export var runWaterAnimeClips: String = "Normal"
@export var attackAnimeClips: String = ""
@export var attackWaterAnimeClips: String = ""
@onready var moveComponent: MoveComponent = %MoveComponent

var run: bool = false

signal running(mower: TowerDefenseMower)

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    sprite.pause = true
    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(transformPoint, "position:x", 0.0, 0.25).from(-50.0)
    tween.tween_property(shadowSprite, "position:x", 5.0, 0.25).from(-45.0)
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_QUART)
    instance.invincible = true
    add_to_group("Mower", true)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super ._physics_process(delta)
    var mapControl: TowerDefenseMapControl = TowerDefenseManager.GetMapControl()
    if global_position.x > mapControl.config.edge.z:
        queue_free()

    if TowerDefenseMapControl.instance:
        if is_instance_valid(cell):
            var cellPos: Vector2 = TowerDefenseManager.GetMapCellPos(gridPos)
            var gridSize: Vector2 = TowerDefenseManager.GetMapGridSize()
            var offset: Vector2 = global_position - cellPos
            cellPercentage = offset.x / gridSize.x
            inWater = cell.IsWater()
        else:
            inWater = false

func RunEntered() -> void :
    running.emit(self)
    moveComponent.SetVelocity(Vector2.RIGHT * 200.0)
    sprite.pause = false
    AudioManager.AudioPlay("Mower", AudioManagerEnum.TYPE.SFX)
    sprite.SetAnimation("Normal", true)

@warning_ignore("unused_parameter")
func RunProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 3.0
    if CanSleep():
        Sleep()

func RunExited() -> void :
    pass

func HitCheck(area: Area2D) -> void :
    var character = area.get_parent()
    if character is TowerDefenseCharacter:
        if character.instance.die || character.instance.nearDie:
            return
        if character is TowerDefenseGravestone:
            return
        if character is TowerDefenseCrater:
            return
        if !CanCollision(character.instance.maskFlags):
            return
        if CheckDifferentCamp(character.camp) && CheckSameLine(character.gridPos.y):
            if !run:
                Run()
                run = true
            config.mowerConfig.Execute(character)
            Hit(character)

func Hit(character: TowerDefenseCharacter) -> void :
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var puff = TowerDefenseManager.CreateEffectSpriteOnce(MOWER_PUFF, gridPos)
    puff.global_position = transformPoint.global_position
    characterNode.add_child(puff)
    if character.config is TowerDefenseZombieConfig:
        if character.config.physique >= TowerDefenseEnum.ZOMBIE_PHYSIQUE.HUGE:
            character.Hurt(100000, false)
            return
    var hit = MOWER_HIT.instantiate()
    characterNode.add_child(hit)
    hit.global_position = sprite.global_position + Vector2(0, 0)
    hit.Init(character)
    character.HitBoxDestroy()
    character.die = true
    moveComponent.SetVelocity(Vector2.RIGHT * 100.0)
    await get_tree().create_timer(0.25, false).timeout
    moveComponent.SetVelocity(Vector2.RIGHT * 200.0)
    if attackAnimeClips != "":
        if !inWater:
            sprite.SetAnimation(attackAnimeClips, false)
            sprite.AddAnimation(runAnimeClips, 0, true, 0.1)
    if attackWaterAnimeClips != "":
        if inWater:
            sprite.SetAnimation(attackWaterAnimeClips, false)
            sprite.AddAnimation(runWaterAnimeClips, 0, true, 0.1)

func Run() -> void :
    state.send_event("ToRun")

func InWater() -> void :
    super .InWater()
    if runWaterAnimeClips != "":
        sprite.SetAnimation(runWaterAnimeClips, true, 0.1)

func OutWater() -> void :
    super .OutWater()
    if runAnimeClips != "":
        sprite.SetAnimation(runAnimeClips, true, 0.1)
