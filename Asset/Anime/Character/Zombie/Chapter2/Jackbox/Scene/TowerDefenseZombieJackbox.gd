@tool
extends TowerDefenseZombie
const JACK_IN_THE_BOX = preload("uid://dhnsy8kekj0nm")
const JACKBOX_EXPLOSION = preload("uid://cxnt2jbnk48fp")

static  var jackInTheBox: AudioStreamPlayerMember

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var hasJackBox: bool = true

func _ready() -> void :
    super._ready()
    if Engine.is_editor_hint():
        return
    if !TowerDefenseManager.currentControl || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if !is_instance_valid(jackInTheBox):
        jackInTheBox = AudioManager.MemberFind("JackInTheBox", AudioManagerEnum.TYPE.SFX)
        jackInTheBox.process_mode = Node.PROCESS_MODE_PAUSABLE

    jackInTheBox.play()
    await get_tree().create_timer(randf_range(15.0, 30.0), false).timeout
    if !hasJackBox || nearDie || die:
        return
    state.send_event("ToBomb")

func HitpointsNearDie() -> void :
    super.HitpointsNearDie()
    if !is_instance_valid(jackInTheBox):
        jackInTheBox = AudioManager.MemberFind("JackInTheBox", AudioManagerEnum.TYPE.SFX)
    jackInTheBox.queue_free()

func BombEntered() -> void :
    if !is_instance_valid(jackInTheBox):
        jackInTheBox = AudioManager.MemberFind("JackInTheBox", AudioManagerEnum.TYPE.SFX)
    jackInTheBox.queue_free()
    AudioManager.AudioPlay("JackSurprise", AudioManagerEnum.TYPE.SFX)
    sprite.SetAnimation("Bomb", false, 0.2)

@warning_ignore("unused_parameter")
func BombProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 1.0

func BombExited() -> void :
    pass

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Bomb":
            CreateEffect()
            Destroy()

func ArmorHitpointsEmpty(armorName: String) -> void :
    super.ArmorHitpointsEmpty(armorName)
    match armorName:
        "Jackbox":
            hasJackBox = false

func CreateEffect() -> void :
    ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 5.0, 0.05, 4)
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(JACKBOX_EXPLOSION, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = global_position
    characterNode.add_child(effect)
    TowerDefenseExplode.CreateExplode(global_position, Vector2(1.5, 1.5), eventList, [], camp, -1)
    AudioManager.AudioPlay("ExplodeCherrybomb", AudioManagerEnum.TYPE.SFX)
