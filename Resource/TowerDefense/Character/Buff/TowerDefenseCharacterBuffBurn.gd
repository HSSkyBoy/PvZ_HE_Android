class_name TowerDefenseCharacterBuffBurn extends TowerDefenseCharacterBuffConfig

@export var time: float = 3.0
@export var dpsAttack: float = 100.0
@export_enum("Particles", "Sprite") var splatSceneType: String = "Particles"
@export var splatScene: PackedScene
@export var splatInterval: float = 1.0

var currentTime: float = 0.0
var splatTime: float = 0.0

func _init() -> void :
    key = "Burn"

func Enter() -> void :
    splatTime = splatInterval

@warning_ignore("unused_parameter")
func Step(delta: float) -> bool:
    currentTime += delta
    if splatScene:
        splatTime += delta
        if splatTime > splatInterval:
            var effect
            match splatSceneType:
                "Particles":
                    effect = TowerDefenseManager.CreateEffectParticlesOnce(splatScene, character.gridPos)
                "Sprite":
                    effect = TowerDefenseManager.CreateEffectSpriteOnce(splatScene, character.gridPos)
            var charcaterNode: Node2D = TowerDefenseManager.GetCharacterNode()
            charcaterNode.add_child(effect)
            effect.global_position = character.global_position
            splatTime = 0.0
            character.BuffAdd(TowerDefenseCharacterBuffFireHit.new())
    character.FlagHurt(
        dpsAttack * delta, 
        TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITSHIELD + TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.HITBODY + TowerDefenseEnum.PROJECTILE_DAMAGE_FLAG.FIRE, 
        false
    )
    return currentTime > time || character.IsDie()

func Exit() -> void :
    pass

@warning_ignore("unused_parameter")
func Refresh(config: TowerDefenseCharacterBuffConfig) -> void :
    pass
