@tool
extends TowerDefensePlant

const DOOM_SHROOM_EXPLOSION = preload("uid://0hfxonqijrv0")

@onready var attackComponent: AttackComponent = %AttackComponent

@export var grab: AdobeAnimateSprite
@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var over: bool = false

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    if sprite.clip == "Idle":
        instance.invincible = false
        if attackComponent.CanAttack():
            Drag(attackComponent.target)

func Drag(character: TowerDefenseCharacter) -> void :
    if instance.sleep:
        return
    if over:
        return
    over = true
    var dragFlag: bool = true
    if is_instance_valid(character):
        if !character.config.canDragIntoWater:
            dragFlag = false
    instance.invincible = true
    AudioManager.AudioPlay("Floop", AudioManagerEnum.TYPE.SFX)
    grab.visible = true
    grab.SetAnimation("Grab", false)
    grab.global_position = character.global_position
    if dragFlag:
        character.sprite.pause = true
        character.HitBoxDestroy()
    itemLayer = TowerDefenseEnum.LAYER_GROUNDITEM.EFFECT
    await get_tree().create_timer(0.5).timeout








    CreateSplash()
    ViewManager.FullScreenColorBlink(Color.DARK_SLATE_BLUE, 0.5, false)
    ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 5.0, 0.05, 4)
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(DOOM_SHROOM_EXPLOSION, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = transformPoint.global_position - Vector2(0, 25)
    characterNode.add_child(effect)
    TowerDefenseExplode.CreateExplode(global_position, Vector2(3.5, 3.5), eventList, [], camp, -1)
    AudioManager.AudioPlay("ExplodeDoomShroom", AudioManagerEnum.TYPE.SFX)
    if dragFlag:
        if is_instance_valid(character):
            character.Destroy()

    Destroy()

    CraterCreate(true)
