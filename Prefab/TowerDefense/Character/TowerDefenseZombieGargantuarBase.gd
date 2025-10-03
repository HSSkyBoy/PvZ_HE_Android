@tool
class_name TowerDefenseZombieGargantuarBase extends TowerDefenseZombie

@export var fireAnimeClip: String = "Fire"
@export var smashAnimeEvent: String = "smash"
@export var impFireEvent: String = "fire"
@export var impName: String = ""
@export var impSpawnSlot: AdobeAnimateSlot
@export_multiline var impFilter: String:
    set(_impFliter):
        impFilter = _impFliter
        impFliters = Array(Array(impFilter.split("&", false)), TYPE_STRING, "", null)

@export_storage var impFliters: Array[String] = []

@export var impThrowDamagePointName: String = "ThrowImp"

var impThrowFlag: bool = false

func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    if impThrowFlag:
        Fire()

func WalkProcessing(delta: float) -> void :
    super.WalkProcessing(delta)
    if impThrowFlag:
        Fire()

func AttackEntered():
    sprite.SetAnimation(attackAnimeClip, true, 0.2)

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    sprite.timeScale = timeScale

func FireEntered():
    impThrowFlag = false
    sprite.SetAnimation(fireAnimeClip, false, 0.2)

@warning_ignore("unused_parameter")
func FireProcessing(delta: float) -> void :
    sprite.timeScale = timeScale

func FireExited() -> void :
    pass

func Fire():
    state.send_event("ToFire")

@warning_ignore("unused_parameter")
func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        attackAnimeClip:
            if !attackComponent.CanAttack():
                Walk()
        fireAnimeClip:
            Walk()
        dieAnimeClip:
            AudioManager.AudioPlay("GargantuarThump", AudioManagerEnum.TYPE.SFX)

@warning_ignore("unused_parameter")
func AnimeEvent(command: String, argument: Variant) -> void :
    super.AnimeEvent(command, argument)
    match command:
        smashAnimeEvent:
            ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 2.0, 0.05, 4)
            AudioManager.AudioPlay("GargantuarThump", AudioManagerEnum.TYPE.SFX)
            attackComponent.SmashAttackCell(config.smashAttack)
        impFireEvent:
            ImpFliterSet()
            ImpSpawn()

func DamagePointReach(damangePointName: String):
    super.DamagePointReach(damangePointName)
    match damangePointName:
        impThrowDamagePointName:
            var mapControl: TowerDefenseMapControl = TowerDefenseManager.GetMapControl()
            if mapControl:
                if global_position.x > mapControl.config.edge.x + TowerDefenseManager.GetMapGridSize().x * 5.0:
                    impThrowFlag = true
        dieAnimeClip:
            AudioManager.AudioPlay("GargantuarDeath", AudioManagerEnum.TYPE.SFX)

func ImpFliterSet(open: bool = false):
    sprite.SetFliters(impFliters, open)

func ImpSpawn():
    var impConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(impName)
    var height: float = GetGroundHeight(impSpawnSlot.global_position.y)
    var imp: TowerDefenseZombieImpBase = impConfig.Create(Vector2(impSpawnSlot.global_position.x, global_position.y), gridPos, height) as TowerDefenseZombieImpBase
    imp.ySpeed = -120.0
    imp.throw = true
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    characterNode.add_child(imp)
    if instance.hypnoses:
        imp.Hypnoses()
    var landPosX: float = randf_range(TowerDefenseManager.GetMapCellPos(Vector2(3, 0)).x, TowerDefenseManager.GetMapCellPos(Vector2(5, 0)).x)
    var tween = create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_LINEAR)
    tween.tween_property(imp, "global_position:x", landPosX, imp.GetFallTime())
