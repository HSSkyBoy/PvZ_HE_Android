extends Node2D

const HAMMER_EXPLOSION = preload("res://Prefab/Particles/Explosion/Hammer/HammerExplosion.tscn")

@onready var hammer: AdobeAnimateSpriteBase = %Hammer

var shape: RectangleShape2D = RectangleShape2D.new()
var params = PhysicsShapeQueryParameters2D.new()
var isAttack: bool = false
var checkCharacterList: Array
func _ready() -> void :
    params.shape = shape
    params.collide_with_areas = true
    params.collision_mask = 1

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
    if TowerDefenseManager.currentControl.isGameFail:
        return
    hammer.global_position = get_global_mouse_position()
    if Input.is_action_just_pressed("Press"):
        AudioManager.AudioPlay("Swing", AudioManagerEnum.TYPE.SFX)
        hammer.SetAnimation("WhackZombie", false, 0.1)
        isAttack = true
        checkCharacterList.clear()
        Attack()

func Attack() -> void :
    if !isAttack:
        return
    isAttack = false
    var pos: Vector2 = hammer.global_position
    shape.size = Vector2(40, 80)
    params.transform = Transform2D(0, pos)
    await get_tree().physics_frame
    var arr = get_world_2d().direct_space_state.intersect_shape(params)
    for infor: Dictionary in arr:
        if infor["collider"] is Area2D:
            var area: Area2D = infor["collider"]
            var character = area.get_parent()
            if character is TowerDefenseCharacter:
                if checkCharacterList.has(character):
                    return
                if character.isRise:
                    continue
                if character.camp != TowerDefenseEnum.CHARACTER_CAMP.PLANT:
                    AudioManager.AudioPlay("Bonk", AudioManagerEnum.TYPE.SFX)
                    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
                    var effect = TowerDefenseManager.CreateEffectParticlesOnce(HAMMER_EXPLOSION, character.gridPos)
                    effect.global_position = hammer.global_position
                    characterNode.add_child(effect)
                    checkCharacterList.append(character)
                    var attackNum = 400
                    if character.instance.armorList.size() > 0:
                        attackNum = min(attackNum, character.instance.armorList[0].hitPoints)
                    var num = character.Hurt(attackNum, true)
                    if num > 0 || character.instance.hitpoints <= character.config.hitpointsNearDeath:
                        if randf() < 0.1:
                            for i in 3:
                                character.SunCreate(character.global_position, 25, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
                        character.Destroy()
                    return

func AnimeCompleted(clip: String) -> void :
    match clip:
        "WhackZombie":
            hammer.SetAnimation("Idle", false, 0.1)
