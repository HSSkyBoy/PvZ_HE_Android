@tool
extends TowerDefenseZombie

const ZAMBONI_EXPLOSION = preload("uid://bbsti03vlotx6")

@onready var zamboniSmoke: GPUParticles2D = %ZamboniSmoke
@onready var iceCapMarker: Marker2D = %IceCapMarker

var speed: float = 20.0
var audioPlay: bool = false

@warning_ignore("unused_parameter")
func WalkProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 0.5
    if global_position.x > TowerDefenseManager.GetMapGroundRight():
        global_position.x -= speed * delta * sprite.timeScale * transformPoint.scale.x * 2.0
    else:
        global_position.x -= speed * delta * sprite.timeScale * transformPoint.scale.x
    if !audioPlay:
        if global_position.x < TowerDefenseManager.GetMapGroundRight():
            AudioManager.AudioPlay("Zamboni", AudioManagerEnum.TYPE.SFX)
            audioPlay = true
    TowerDefenseMapControl.instance.SetIceCapPos(gridPos.y, iceCapMarker.global_position)

    if attackComponent.CanAttack():
        if !attackComponent.target.instance.physiqueTypeFlags & TowerDefenseEnum.CHARACTER_PHYSIQUE_TYPE.SPIKE:
            attackComponent.SmashAttackCell(config.smashAttack)
        else:
            if attackComponent.target.config.spikeHurt != -1:
                attackComponent.target.Hurt(attackComponent.target.config.spikeHurt)
            Die()

    if instance.hitpoints < (config.hitpoints + config.hitpointsNearDeath) * 0.2:
        speed -= delta * 0.5
        sprite.shake = true

func HitpointsEmpty() -> void :
    super.HitpointsEmpty()
    CreateEffect()
    Destroy()

func DamagePointReach(damangePointName: String) -> void :
    super.DamagePointReach(damangePointName)
    match damangePointName:
        "DamagePoint2":
            speed = 17.5
        "DamagePoint3":
            speed = 15.0
            zamboniSmoke.visible = true

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Wheelie":
            CreateEffect()
        "Wheelie2":
            CreateEffect()

func CreateEffect() -> void :
    AudioManager.AudioPlay("ZamboniExplosion", AudioManagerEnum.TYPE.SFX)
    ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 5.0, 0.05, 4)
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(ZAMBONI_EXPLOSION, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = global_position
    characterNode.add_child(effect)
