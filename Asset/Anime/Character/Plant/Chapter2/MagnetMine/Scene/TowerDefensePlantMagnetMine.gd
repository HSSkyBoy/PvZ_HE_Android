@tool
extends TowerDefensePlant

const MINE_EXPLOSION = preload("uid://dqcu2ycvf4u72")
const MINE_RISE_DIRT = preload("uid://cov352ltsv2sg")
@onready var attackComponent: AttackComponent = %AttackComponent
@onready var attackComponent2: AttackComponent = %AttackComponent2
@onready var magnetComponent: MagnetComponent = %MagnetComponent

@export var readyTime: float = 5.0
@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var drawCharacter: Array = []

var rise: bool = false

var over: bool = false

func ReadyEntered() -> void :
    if !inGame:
        return
    sprite.SetAnimation("Ready", true)
    await get_tree().create_timer(readyTime, false).timeout

    ReadyRise()

@warning_ignore("unused_parameter")
func ReadyProcessing(delta: float) -> void :
    sprite.timeScale = timeScale

func ReadyExited() -> void :
    pass

func FireEntered() -> void :
    sprite.SetAnimation("Fire", false)
    var gridSize = TowerDefenseManager.GetMapGridSize()
    for character: TowerDefenseCharacter in drawCharacter:
        if is_instance_valid(character):
            character.saveShadowPosition.y += gridSize.y * (gridPos.y - character.gridPos.y)
            character.gridPos.y = gridPos.y
            var tween = character.create_tween()
            tween.set_ease(Tween.EASE_OUT)
            tween.set_trans(Tween.TRANS_QUART)
            tween.tween_property(character, ^"global_position", global_position, 0.5)

@warning_ignore("unused_parameter")
func FireProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 2.0

func FireExited() -> void :
    pass

func IdleEntered() -> void :
    super .IdleEntered()
    instance.invincible = true
    sprite.SetAnimation("Rise", false, 0.2)
    sprite.AddAnimation("Idle", 0.0, true, 0.2)

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    if sprite.clip == "Idle":
        instance.invincible = true
        drawCharacter = await magnetComponent.GetCanArmorDrawCharacterList()
        if drawCharacter.size() > 0:
            state.send_event("ToFire")
            return
        if attackComponent.CanAttack():
            Explode()

        if attackComponent2.CanAttack():
            sprite.timeScale = timeScale * 2.0

func IdleExited() -> void :
    super .IdleExited()

func ReadyRise() -> void :
    if rise:
        return
    rise = true
    Idle()
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(MINE_RISE_DIRT, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = global_position
    characterNode.add_child(effect)

func Explode() -> void :
    Destroy()

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Fire":
            Explode()

func DestroySet() -> void :
    if !rise:
        return
    if over:
        return
    over = true
    ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 3.0, 0.05, 4)
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(MINE_EXPLOSION, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = global_position
    characterNode.add_child(effect)
    await get_tree().physics_frame
    TowerDefenseExplode.CreateExplode(global_position, Vector2(1.0, 0.25), eventList, [], camp, -1)
    AudioManager.AudioPlay("MineExplosion", AudioManagerEnum.TYPE.SFX)
