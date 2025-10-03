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
    AudioManager.AudioPlay("Floop", AudioManagerEnum.TYPE.SFX)
    instance.invincible = true
    grab.visible = true
    grab.SetAnimation("Grab", false)
    grab.global_position = character.global_position
    if dragFlag:
        character.sprite.pause = true
        character.hitBox.monitorable = false
    itemLayer = TowerDefenseEnum.LAYER_GROUNDITEM.EFFECT
    await get_tree().create_timer(0.5).timeout


















    CreateSplash()
    if dragFlag:
        if is_instance_valid(character):
            var tween = character.create_tween()
            tween.set_ease(Tween.EASE_OUT)
            tween.set_trans(Tween.TRANS_BACK)
            tween.set_parallel(true)
            tween.tween_property(character.transformPoint, ^"scale", Vector2.ONE, 0.5).from(Vector2.ONE * 0.5)


            character.Hypnoses()
            character.global_position.x = global_position.x
            character.sprite.pause = false
            character.hitBox.monitorable = true

            if !character.instance.hypnoses:
                character.Destroy()
    Destroy()
