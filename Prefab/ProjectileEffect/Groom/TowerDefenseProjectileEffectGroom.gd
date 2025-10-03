extends TowerDefenseProjectileEffectBase

var num: int = 4

func _ready() -> void :
    AttackCreate()

func AttackCreate() -> void :
    num -= 1
    AudioManager.AudioPlay("SplatNormal", AudioManagerEnum.TYPE.SFX)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    var efect = ObjectManager.PoolPop(ObjectManagerConfig.OBJECT.PARTICLES_GLOOM_SPLATS, characterNode)
    efect.global_position = global_position
    efect.gridPos = gridPos
    TowerDefenseExplode.CreateExplode(global_position, Vector2(1.25, 1.25), eventList, [], camp, collisionFlag)
    if num <= 0:
        queue_free()
