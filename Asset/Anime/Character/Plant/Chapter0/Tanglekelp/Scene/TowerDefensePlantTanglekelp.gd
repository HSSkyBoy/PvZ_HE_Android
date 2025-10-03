@tool
extends TowerDefensePlant

@onready var attackComponent: AttackComponent = %AttackComponent

@export var grab: AdobeAnimateSprite

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
    if dragFlag:
        if is_instance_valid(character):
            character.Destroy()

    Destroy()
