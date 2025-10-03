@tool
extends TowerDefensePlant

const SUN_BOMB_EXPLOSION = preload("uid://b73i0bacl5jnh")

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var over: bool = false

func IdleEntered() -> void :
    super.IdleEntered()
    if !inGame:
        return
    instance.invincible = true
    AudioManager.AudioPlay("ReverseExplosion", AudioManagerEnum.TYPE.SFX)
    sprite.SetAnimation("Explode", false)

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    sprite.timeScale = timeScale * 0.5

func IdleExited() -> void :
    super.IdleExited()

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Explode":
            Destroy()

func DestroySet() -> void :
    if sprite.clip != "Explode":
        return
    if over:
        return
    over = true
    ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 5.0, 0.05, 4)
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(SUN_BOMB_EXPLOSION, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = global_position
    characterNode.add_child(effect)
    TowerDefenseExplode.CreateExplode(global_position, Vector2(1.5, 1.5), eventList, [], camp, -1)
    AudioManager.AudioPlay("ExplodeCherrybomb", AudioManagerEnum.TYPE.SFX)
