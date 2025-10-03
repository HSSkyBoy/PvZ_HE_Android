class_name ReverseInjuryComponent extends ComponentBase

@export_enum("StaticTime", "Dps") var attackMethod: String = "StaticTime"
@export var eventList: Array[TowerDefenseCharacterEventBase]
@export var staticTime: float = 1.0

@export_enum("Particles", "Sprite") var targetEffectType: String = "Particles"
@export var targetEffectScene: PackedScene

var parent: TowerDefenseCharacter

var timer: float = 0.0

func _ready() -> void :
    parent = get_parent()

func _physics_process(delta: float) -> void :
    if !alive:
        return
    if !is_instance_valid(parent.hitBox):
        return
    match attackMethod:
        "StaticTime":
            timer += delta
            if timer > staticTime:
                EventExecute()
                timer -= staticTime
        "Dps":
            EventExecuteDps(delta)

func EventExecute() -> void :
    if !is_instance_valid(parent.hitBox):
        return
    for area: Area2D in parent.hitBox.get_overlapping_areas():
        var character = area.get_parent()
        if character is TowerDefenseCharacter:
            if !parent.CanTarget(character):
                continue
            if !parent.CanCollision(character.instance.maskFlags):
                continue
            for event: TowerDefenseCharacterEventBase in eventList:
                event.Execute(character.global_position, character)
                if targetEffectScene:
                    CreateSplat(character)

func EventExecuteDps(delta: float) -> void :
    if !is_instance_valid(parent.hitBox):
        return
    for area: Area2D in parent.hitBox.get_overlapping_areas():
        var character = area.get_parent()
        if character is TowerDefenseCharacter:
            if !parent.CanTarget(character):
                continue
            if !parent.CanCollision(character.instance.maskFlags):
                continue
            for event: TowerDefenseCharacterEventBase in eventList:
                event.ExecuteDps(character.global_position, character, delta)
                if targetEffectScene:
                    CreateSplat(character)


func CreateSplat(character: TowerDefenseCharacter) -> void :
    var splatEffect
    match targetEffectType:
        "Particles":
            splatEffect = TowerDefenseManager.CreateEffectParticlesOnce(targetEffectScene, character.gridPos)
        "Sprite":
            splatEffect = TowerDefenseManager.CreateEffectSpriteOnce(targetEffectScene, character.gridPos)
    var charcaterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    charcaterNode.add_child(splatEffect)
    splatEffect.global_position = character.global_position
