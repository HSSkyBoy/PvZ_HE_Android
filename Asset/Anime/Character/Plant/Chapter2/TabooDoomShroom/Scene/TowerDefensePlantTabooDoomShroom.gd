@tool
extends TowerDefensePlant

const TABOO_DOOM_SHROOM_EXPLOSION = preload("uid://bgrs063lpcf7a")

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var over: bool = false

func SleepEntered() -> void :
    super .SleepEntered()
    instance.invincible = false

func IdleEntered() -> void :
    super .IdleEntered()
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if !inGame:
        return
    instance.invincible = true
    AudioManager.AudioPlay("ReverseExplosion", AudioManagerEnum.TYPE.SFX)
    sprite.SetAnimation("Explode", false)

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    sprite.timeScale = timeScale * 1.5

func IdleExited() -> void :
    super .IdleExited()

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Explode":
            Destroy()

func DestroySet() -> void :
    if sprite.clip != "Explode":
        return
    if over:
        return
    over = true
    ViewManager.FullScreenColorBlink(Color.DARK_SLATE_BLUE, 0.5, false)
    ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 5.0, 0.05, 4)
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(TABOO_DOOM_SHROOM_EXPLOSION, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = transformPoint.global_position - Vector2(0, 25)
    characterNode.add_child(effect)
    await get_tree().physics_frame
    TowerDefenseExplode.CreateExplode(global_position, Vector2(3.5, 3.5), eventList, [], camp, -1)
    AudioManager.AudioPlay("ExplodeDoomShroom", AudioManagerEnum.TYPE.SFX)
    cell.Clear()
    await get_tree().physics_frame
    CraterCreate(true)
