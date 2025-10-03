@tool
extends TowerDefensePlant

@onready var attackComponent: AttackComponent = %AttackComponent
@onready var checkArea: Area2D = %CheckArea
@onready var checkShape: CollisionShape2D = %CheckShape

@export var chewTime: float = 30.0

var target: TowerDefenseCharacter

var isSuck: bool = true
var eatZombie: bool = false

var chewTimer: float = 0.0

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    checkShape.shape.b.x = TowerDefenseManager.GetMapGridSize().x * 1.75

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    sprite.timeScale = timeScale * 1.5
    if attackComponent.CanAttack():
        isSuck = false
        state.send_event("ToAttack")
        return
    GetTarget()
    if is_instance_valid(target):
        isSuck = true
        state.send_event("ToAttack")
        return

func AttackEntered() -> void :
    sprite.SetAnimation("BiteStart", false, 0.5)
    if isSuck:
        sprite.AddAnimation("BiteLoop", 0.0, true, 0.2)
    else:
        sprite.AddAnimation("BiteEnd", 0.0, false, 0.2)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    if IsDie():
        return
    sprite.timeScale = timeScale * 1.5
    if isSuck:
        if sprite.clip == "BiteLoop":
            if !is_instance_valid(target):
                Idle()
                return
            if target.die || target.nearDie:
                Idle()
                return
            if CanTarget(target) && CanCollision(target.instance.maskFlags):
                if target.global_position.x > global_position.x + 80:
                    target.instance.canCollection = false
                    target.state.process_mode = Node.PROCESS_MODE_DISABLED
                    target.global_position.x -= 200 * delta
                else:
                    sprite.SetAnimation("BiteEnd", false, 0.2)
            else:
                target.instance.canCollection = true
                target.state.process_mode = Node.PROCESS_MODE_INHERIT
                Idle()

func AttackExited() -> void :
    isSuck = false
    eatZombie = false
    target = null

func ChewEntered() -> void :
    chewTimer = 0.0
    sprite.SetAnimation("Chew", true, 0.2)

@warning_ignore("unused_parameter")
func ChewProcessing(delta: float) -> void :
    sprite.timeScale = timeScale
    if sprite.clip == "Chew":
        if chewTimer < chewTime:
            chewTimer += delta
        else:
            sprite.SetAnimation("Swallow", false, 0.2)

func ChewExited() -> void :
    pass

func GetTarget() -> TowerDefenseCharacter:
    var characterList = TowerDefenseManager.GetCharacterTargetLineFromArea(self, checkArea, true)
    characterList.sort_custom(
        func(a: TowerDefenseCharacter, b: TowerDefenseCharacter):
            return abs(a.global_position.x - global_position.x) < abs(b.global_position.x - global_position.x)
    )
    for character: TowerDefenseCharacter in characterList:
        if character is TowerDefenseZombie:
            if character.instance.zombiePhysique <= TowerDefenseEnum.ZOMBIE_PHYSIQUE.NORMAL:
                target = character
                return character
    return null

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "BiteEnd":
            if eatZombie:
                state.send_event("ToChew")
            else:
                Idle()
        "Swallow":
            Idle()

func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "attack":
            AudioManager.AudioPlay("BigChomp", AudioManagerEnum.TYPE.SFX)
            if isSuck:
                if is_instance_valid(target):
                    target.isChomp = true
                    target.Destroy()
                    eatZombie = true
            else:
                if attackComponent.CanAttack():
                    if is_instance_valid(attackComponent.target):
                        if attackComponent.target.die || attackComponent.target.nearDie:
                            return
                        if CanTarget(attackComponent.target) && CanCollision(attackComponent.target.instance.maskFlags):
                            if attackComponent.target is TowerDefenseZombie:
                                if attackComponent.target.instance.zombiePhysique < TowerDefenseEnum.ZOMBIE_PHYSIQUE.HUGE || attackComponent.target.instance.zombiePhysique == TowerDefenseEnum.ZOMBIE_PHYSIQUE.CAR:
                                    attackComponent.target.isChomp = true
                                    attackComponent.target.Destroy()
                                    eatZombie = true
                                else:
                                    attackComponent.target.Hurt(100)
                            if attackComponent.target is TowerDefenseGravestone:
                                attackComponent.target.Hurt(100)
                            if attackComponent.target is TowerDefensePlant:
                                attackComponent.target.isChomp = true
                                attackComponent.target.Destroy()
        "blow":
            var targetList = TowerDefenseManager.GetCharacterTargetLineFromArea(self, checkArea, true)
            for character: TowerDefenseCharacter in targetList:
                if character is TowerDefenseZombie:
                    if character.instance.zombiePhysique >= TowerDefenseEnum.ZOMBIE_PHYSIQUE.BOSS:
                        continue
                if character.instance.unUseBuffFlags == TowerDefenseEnum.CHARACTER_BUFF_FLAGS.ALL:
                    continue
                if character is TowerDefensePlant || character is TowerDefenseGravestone || character is TowerDefenseItem:
                    continue
                if character.instance.zombiePhysique <= TowerDefenseEnum.ZOMBIE_PHYSIQUE.NORMAL:
                    if character.instance.collisionFlags != 0:
                        character.BlowBack(1, 1.0)
                    if character.instance.collisionFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE:
                        character.BlowBack(3, 1.0)
                elif character.instance.zombiePhysique <= TowerDefenseEnum.ZOMBIE_PHYSIQUE.HUGE:
                    character.BlowBack(0.5, 1.0)
            AudioManager.AudioPlay("Blover", AudioManagerEnum.TYPE.SFX)

func DestroySet() -> void :
    if is_instance_valid(target):
        target.instance.set_deferred("canCollection", true)
        target.state.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
        if target is TowerDefenseZombie:
            target.Walk()
    await get_tree().physics_frame
