@tool
class_name TowerDefenseVase extends TowerDefenseItem

@onready var hammer: AdobeAnimateSpriteBase = %Hammer
@onready var packetShow: TowerDefenseInGamePacketShow = %PacketShow
@onready var mouseMask: ColorRect = %MouseMask

@export var waterLineSprite: AdobeAnimateSpriteBase
@export var chunkParticles: PackedScene
@export var packetBank: String = "Total"
@export var packetName: String = "":
    set(_packetName):
        if packetName != _packetName:
            packetName = _packetName
            if packetName == "":
                packetConfig = null
            else:
                packetConfig = TowerDefenseManager.GetPacketConfig(packetName).duplicate(true)
@export var packetConfig: TowerDefensePacketConfig:
    set(_packetConfig):
        packetConfig = _packetConfig
        if is_node_ready():
            if is_instance_valid(packetConfig):
                packetShow.Init(packetConfig)
            else:
                packetShow.Clear()

@export var waterHeightPersontage: float = 0.75
@export var waterHeight: float = 35

var isMoseIn: bool = false
var pressed: bool = false
var over: bool = false

var showPacket: bool = false:
    set(_showPacket):

            showPacket = _showPacket
            if !showPacket:
                packetShow.visible = false
                sprite.SetAnimation("Idle")
            else:
                packetShow.visible = true
                sprite.SetAnimation("Show")

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super ._ready()
    showPacket = true
    showPacket = false
    packetShow.button.visible = false
    packetShow.showCost = false
    add_to_group("Vase", true)
    if !(Global.isEditor && SceneManager.currentScene == "LevelEditorStage"):
        z = 900
        packetShow.position.y = -900
    await get_tree().create_timer(randf_range(0.25, 1.0)).timeout
    if is_instance_valid(cell) && cell.IsWater():
        shadowSprite.visible = false
        var waterTween = create_tween()
        waterTween.set_ease(Tween.EASE_OUT)
        waterTween.set_trans(Tween.TRANS_CUBIC)
        waterTween.tween_property(spriteGroup.material, "shader_parameter/surfaceDownPos", waterHeightPersontage, 1.0)

        groundHeight = - waterHeight
        packetShow.position.y = groundHeight
        CreateSplash()
        if is_instance_valid(waterLineSprite):
            waterLineSprite.visible = true
    if !(Global.isEditor && SceneManager.currentScene == "LevelEditorStage"):
        var tween = create_tween()
        tween.set_parallel(true)
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_QUAD)
        tween.tween_property(self, ^"z", groundHeight, 0.25)
        tween.tween_property(packetShow, ^"position:y", - groundHeight, 0.25)
        tween.set_trans(Tween.TRANS_BOUNCE)
        tween.tween_property(transformPoint, ^"scale", Vector2(0.75, 1.25), 0.25)
        tween.set_parallel(false)
        tween.set_trans(Tween.TRANS_BOUNCE)
        tween.tween_property(transformPoint, ^"scale", Vector2(1.5, 0.5), 0.1)
        tween.tween_property(transformPoint, ^"scale", Vector2.ONE, 0.2)
    else:
        mouseMask.mouse_default_cursor_shape = Control.CURSOR_ARROW

func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    if Engine.is_editor_hint():
        return
    showPacket = CheckShow() || (Global.isEditor && SceneManager.currentScene == "LevelEditorStage")

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        return
    if !TowerDefenseManager.IsGameRunning():
        return
    if !pressed:
        if isMoseIn:
            if Input.is_action_just_pressed("Press"):
                hammer.visible = true
                AudioManager.AudioPlay("Swing", AudioManagerEnum.TYPE.SFX)
                hammer.SetAnimation("OpenPot", false)
                pressed = true

func DestroySet() -> void :
    if over:
        return
    over = true
    AudioManager.AudioPlay("VaseBreaking", AudioManagerEnum.TYPE.SFX)
    var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(chunkParticles, gridPos)
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    effect.global_position = transformPoint.global_position - Vector2(0, 30.0)
    characterNode.add_child(effect)

    if !is_instance_valid(packetConfig):
        var packetBankData: TowerDefensePacketBankData = TowerDefenseManager.GetPacketBankData(packetBank)
        if is_instance_valid(packetBankData):
            var packetList: Array = packetBankData.GetPacketList()
            var packetRandom: String = packetList.pick_random()
            var _packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetRandom)
            if _packetConfig.characterConfig is TowerDefenseZombieConfig:
                while !cell.CanPacketPlant(_packetConfig) && packetList.size() > 1:
                    packetList.erase(packetRandom)
                    packetRandom = packetList.pick_random()
                    _packetConfig = TowerDefenseManager.GetPacketConfig(packetRandom)
                if packetList.size() > 1:
                    var plant = _packetConfig.Plant(gridPos, true)
                    plant.instance.wakeUp = true
                    if instance.hypnoses:
                        plant.Hypnoses()
            else:
                var packetInstance: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()
                packetInstance.z_index = 0 + gridPos.y * TowerDefenseEnum.LAYER_GROUNDITEM.MAX + itemLayer + 7
                packetInstance.global_position = global_position
                characterNode.add_child(packetInstance)
                packetInstance.Init(_packetConfig)
                packetInstance.onlyDraw = false
                packetInstance.showCost = false
                packetInstance.useCost = false
                packetInstance.plantOnce = true
                packetInstance.StartInit()
                packetInstance.alive = true
                packetInstance.aliveTime = 30.0
                var seedBank: TowerDefenseInGameSeedBank = TowerDefenseManager.GetSeedBank()
                packetInstance.pressed.connect(seedBank.PickPacket)
    else:
        if packetConfig.characterConfig is TowerDefenseZombieConfig:
            var plant = packetConfig.Plant(gridPos, true)
            plant.instance.wakeUp = true
            if instance.hypnoses:
                plant.Hypnoses()
        else:
            var packetInstance: TowerDefenseInGamePacketShow = TowerDefenseManager.CreatePacketShow()
            packetInstance.z_index = z_index
            packetInstance.global_position = global_position
            characterNode.add_child(packetInstance)
            packetInstance.Init(packetConfig)
            packetInstance.onlyDraw = false
            packetInstance.showCost = false
            packetInstance.useCost = false
            packetInstance.plantOnce = true
            packetInstance.StartInit()
            packetInstance.alive = true
            packetInstance.aliveTime = 30.0
            var seedBank: TowerDefenseInGameSeedBank = TowerDefenseManager.GetSeedBank()
            packetInstance.pressed.connect(seedBank.PickPacket)
    await get_tree().physics_frame

func SmashDestroy() -> void :
    if isDestroy:
        return
    isDestroy = true
    await DestroySet()
    queue_free()

func MouseEntered() -> void :
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        return
    SetSpriteGroupShaderParameter("brightStrength", 0.3)
    isMoseIn = true

func MouseExited() -> void :
    if Global.isEditor && SceneManager.currentScene == "LevelEditorStage":
        return
    SetSpriteGroupShaderParameter("brightStrength", 0.0)
    isMoseIn = false

func HammerAnimeCompleted(clip: String) -> void :
    match clip:
        "OpenPot":
            hammer.visible = false
            Destroy()

func CheckShow() -> bool:
    var flag: bool = false
    for i in range(-1, 2, 1):
        for j in range(-1, 2, 1):
            if i == 0 && j == 0:
                continue
            var checkCell: TowerDefenseCellInstance = TowerDefenseManager.GetMapCell(gridPos + Vector2i(i, j))
            if is_instance_valid(checkCell):
                if checkCell.HasLight():
                    flag = true
                    break
        if flag:
            break
    return flag

func Export() -> TowerDefenseLevelVaseConfig:
    var vaseConfig: TowerDefenseLevelVaseConfig = TowerDefenseLevelVaseConfig.new()
    vaseConfig.gridPos = gridPos
    if is_instance_valid(packetConfig):
        vaseConfig.packetName = packetConfig.saveKey
    match config.name:
        "VaseNormal":
            vaseConfig.type = "Normal"
        "VasePlant":
            vaseConfig.type = "Plant"
        "VaseZombie":
            vaseConfig.type = "Zombie"
    return vaseConfig
