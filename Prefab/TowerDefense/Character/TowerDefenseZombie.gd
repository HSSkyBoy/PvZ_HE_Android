@tool
class_name TowerDefenseZombie extends TowerDefenseCharacter

const ZOMBIE_HEAD_GROSSOUT = preload("uid://bbidqxovk4j7y")

@onready var groundMoveComponent: GroundMoveComponent = %GroundMoveComponent
@onready var attackComponent: AttackComponent = %AttackComponent

@export var groan: String
@export var walkSpeedScale: float = 1.0
@export var useAttackDps: bool = true

@export var walkAnimeClip: String = "Walk"
@export var inSwimAnimeClip: String = ""
@export var swimAnimeClip: String = "Walk"
@export var outSwimAnimeClip: String = ""
@export var attackAnimeClip: String = "Eat"
@export var attackWaterAnimeClip: String = ""
@export var dieAnimeClip: String = "Death"
@export var dieWaterAnimeClip: String = "Death"
@export var duckytobeSprite: AdobeAnimateSprite
@export var waterLineSprite: AdobeAnimateSprite
@export_multiline var waterAnimeFliter: String = ""
@export var garlicFliters: Array[String] = ["anim_head2", "anim_tongue"]
@export var garlicReplace: String = "Zombie_head.png"

@export var waterHeightPersontage: float = 0.75
@export var waterHeight: float = 35
var isGarlic: bool = false

var inWaterLine: bool = false
var inSwimPlay: bool = false
var inGround: bool = false
var onLadder: bool = false
var startAttack: bool = false

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()

    timeScale += randf_range(-0.1, 0.1)
    add_to_group("Zombie", true)
    walkSpeedScale += walkSpeedScale * randf_range(-0.1, 0.1)
    instance.hitpointsEmpty.connect(Die)

    if is_instance_valid(duckytobeSprite):
        if TowerDefenseMapControl.instance && TowerDefenseMapControl.instance.LineHasType(gridPos.y, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
            inWaterLine = true
            duckytobeSprite.visible = true

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super._physics_process(delta)
    if TowerDefenseMapControl.instance:
        var cell = TowerDefenseManager.GetMapCell(gridPos)
        if is_instance_valid(cell):
            inWater = cell.IsWater() && !instance.collisionFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE
            onLadder = is_instance_valid(cell.characterLadder) && config.physique < TowerDefenseEnum.ZOMBIE_PHYSIQUE.HUGE && scale.x > 0.0
            if onLadder:
                var cellPos: Vector2 = TowerDefenseManager.GetMapCellPos(gridPos)
                var gridSize: Vector2 = TowerDefenseManager.GetMapGridSize()
                var offset: Vector2 = global_position - cellPos
                var percentage: float = offset.x / gridSize.x
                if percentage > 0.5:
                    groundHeight = lerpf(groundHeight, 60, 2.0 * delta)
                else:
                    groundHeight = lerpf(groundHeight, 0, 2.0 * delta)
            elif !inWater:
                groundHeight = lerpf(groundHeight, 0, 2.0 * delta)
        else:
            inWater = false
    if !inGround:
        if global_position.x < TowerDefenseManager.GetMapGroundRight() + 20:
            inGround = true
            if inGame:
                await get_tree().create_timer(randf_range(0.5, 3.0), false).timeout
                AudioManager.AudioPlay(groan, AudioManagerEnum.TYPE.SFX)
    if scale.x < 0:
        if global_position.x > TowerDefenseManager.GetMapGroundRight() + 60:
            Destroy()
    showHealthComponent.alive = GameSaveManager.GetConfigValue("ShowZombieHealth")



func IdleEntered() -> void :
    super.IdleEntered()

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    if isRise:
        return
    sprite.timeScale = timeScale
    if attackComponent.CanAttack():
        Attack()

func IdleExited() -> void :
    super.IdleExited()

func GarlicEntered() -> void :
    pass

@warning_ignore("unused_parameter")
func GarlicProcessing(delta: float) -> void :
    sprite.timeScale = 0.0

func GarlicExited() -> void :
    pass

func WalkEntered() -> void :
    if inWater:
        if !inSwimPlay && inSwimAnimeClip != "":
            sprite.SetAnimation(inSwimAnimeClip, false, 0.2)
            sprite.AddAnimation(swimAnimeClip, 0.0, true, 0.2)
            inSwimPlay = true
        else:
            sprite.SetAnimation(swimAnimeClip, true, 0.2)
    else:
        sprite.SetAnimation(walkAnimeClip, true, 0.2)
    groundMoveComponent.alive = true

@warning_ignore("unused_parameter")
func WalkProcessing(delta: float) -> void :
    if global_position.x > TowerDefenseManager.GetMapGroundRight():
        sprite.timeScale = timeScale * walkSpeedScale * 2.0
    else:
        sprite.timeScale = timeScale * walkSpeedScale
    if !sprite.pause && attackComponent.CanAttack():
        Attack()

func WalkExited() -> void :
    if !instance.die:
        groundMoveComponent.alive = false

func AttackEntered() -> void :
    if inWater && attackWaterAnimeClip != "":
        sprite.SetAnimation(attackWaterAnimeClip, true, 0.2)
    else:
        sprite.SetAnimation(attackAnimeClip, true, 0.2)
    startAttack = false
    await get_tree().create_timer(0.1 / sprite.timeScale, false).timeout
    startAttack = true

@warning_ignore("unused_parameter")
func AttackProcessing(delta: float) -> void :
    if !attackComponent.CanAttack():
        Walk()
    else:
        if startAttack && !nearDie && !sprite.pause && useAttackDps:
            attackComponent.AttackDps(delta, config.attack)
    sprite.timeScale = timeScale * 2.0

func AttackExited() -> void :
    pass

func DieEntered() -> void :
    if camp == TowerDefenseEnum.CHARACTER_CAMP.ZOMBIE:
        if GameSaveManager.GetFeatureValue("Coins"):
            var item = TowerDefenseManager.FallingObjectCreate(global_position, GetGroundHeight(global_position.y), Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
            if item:
                item.gridPos = gridPos
    if inWater:
        sprite.SetAnimation(dieWaterAnimeClip, false, 0.2)
        if is_instance_valid(duckytobeSprite):
            var tween = create_tween()
            tween.set_parallel(true)
            tween.set_ease(Tween.EASE_OUT)
            tween.set_trans(Tween.TRANS_CUBIC)
            tween.tween_property(self, "groundHeight", -100.0, 1.0)
            tween.tween_property(spriteGroup.material, "shader_parameter/surfaceDownPos", 0.0, 4.0)
    else:
        sprite.SetAnimation(dieAnimeClip, false, 0.2)

@warning_ignore("unused_parameter")
func DieProcessing(delta: float) -> void :
    sprite.timeScale = timeScale



func Walk() -> void :
    state.send_event("ToWalk")

func Attack() -> void :
    state.send_event("ToAttck")

func Die() -> void :
    state.send_event("ToDie")

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    if dieAnimeClip.split("&", false).has(clip):
        var tween = create_tween()
        tween.tween_property(self, "modulate:a", 0.0, 0.5)
        await tween.finished
        Destroy()
        return
    elif dieWaterAnimeClip.split("&", false).has(clip):
        Destroy()
        return

    if die:
        Die()

func Garlic() -> void :
    if isGarlic:
        return
    isGarlic = true
    state.send_event("ToGarlic")
    await get_tree().create_timer(0.5, false).timeout
    AudioManager.AudioPlay("Yuck", AudioManagerEnum.TYPE.SFX)
    var replaceUse: Array[bool] = []
    replaceUse.resize(garlicFliters.size())
    replaceUse.fill(true)
    var saveReplace: Texture2D = sprite.GetReplace(garlicReplace)
    sprite.SetReplace(garlicReplace, ZOMBIE_HEAD_GROSSOUT)
    for id in garlicFliters.size():
        replaceUse[id] = sprite.GetFliter(garlicFliters[id])
    sprite.SetFliters(garlicFliters, false)
    await get_tree().create_timer(0.5, false).timeout
    sprite.SetReplace(garlicReplace, saveReplace)
    if !nearDie && !die:
        Walk()
        for id in garlicFliters.size():
            if replaceUse[id]:
                sprite.SetFliter(garlicFliters[id], true)
    var mapGridNum: Vector2i = TowerDefenseManager.GetMapGridNum()
    var mapGridSize: Vector2 = TowerDefenseManager.GetMapGridSize()
    var moveDir = 0
    if gridPos.y == 1:
        moveDir = 1
    elif gridPos.y == mapGridNum.y:
        moveDir = -1
    elif randf() > 0.5:
        moveDir = 1
    else:
        moveDir = -1
    var tween = create_tween()
    tween.tween_property(self, ^"global_position:y", global_position.y + mapGridSize.y * moveDir, 1.0)
    gridPos.y += moveDir
    saveShadowPosition.y += mapGridSize.y * moveDir
    await tween.finished
    isGarlic = false

func Hypnoses(time: float = -1) -> void :
    super.Hypnoses(time)
    if instance.unUseBuffFlags & TowerDefenseEnum.CHARACTER_BUFF_FLAGS.HYPNOSES:
        return
    attackComponent.target = null
    if time == -1:
        bodyHurt.emit(GetTotalHitPoint())

func InWater() -> void :
    super.InWater()
    var tween = create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(spriteGroup.material, "shader_parameter/surfaceDownPos", waterHeightPersontage, 1.0)

    groundHeight = - waterHeight
    CreateSplash()
    if is_instance_valid(waterLineSprite):
        waterLineSprite.visible = true
    if is_instance_valid(duckytobeSprite):
        if !duckytobeSprite.visible:
            duckytobeSprite.visible = true
        if inWaterLine:
            duckytobeSprite.SetFliters(["Zombie_duckytube_inwater"], true)
            duckytobeSprite.SetFliters(["Zombie_duckytube"], false)
        else:
            duckytobeSprite.SetFliters(["Zombie_duckytube_inwater", "Zombie_duckytube"], false)
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        return
    if !is_instance_valid(TowerDefenseManager.currentControl) || !TowerDefenseManager.currentControl.isGameRunning:
        return
    if swimAnimeClip != walkAnimeClip:
        if !die && !nearDie:
            Walk()

func OutWater() -> void :
    super.OutWater()
    inSwimPlay = false
    if outSwimAnimeClip != "":
        sprite.SetAnimation(outSwimAnimeClip, false, 0.2)
    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(spriteGroup.material, "shader_parameter/surfaceDownPos", 1.0, 1.0)
    tween.tween_property(self, "groundHeight", 0.0, 1.0)

    if is_instance_valid(waterLineSprite):
        waterLineSprite.visible = false
    if is_instance_valid(duckytobeSprite):
        if inWaterLine:
            duckytobeSprite.SetFliters(["Zombie_duckytube_inwater"], false)
            duckytobeSprite.SetFliters(["Zombie_duckytube"], true)
        else:
            duckytobeSprite.SetFliters(["Zombie_duckytube_inwater", "Zombie_duckytube"], false)
    if swimAnimeClip != walkAnimeClip:
        if !die && !nearDie:
            Walk()
