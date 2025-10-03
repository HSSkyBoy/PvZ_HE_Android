@tool
extends TowerDefenseGravestone

const CHERRY_BOMB_EXPLOSION = preload("uid://cibtjjjomdxnh")

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var boom: bool = false

func DestroySet() -> void :
    if boom:
        return
    boom = true
    ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 5.0, 0.05, 4)
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(CHERRY_BOMB_EXPLOSION, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = global_position
    characterNode.add_child(effect)
    TowerDefenseExplode.CreateExplode(global_position, Vector2(1.5, 1.5), eventList, [], TowerDefenseEnum.CHARACTER_CAMP.NOONE, -1)
    AudioManager.AudioPlay("ExplodeCherrybomb", AudioManagerEnum.TYPE.SFX)
