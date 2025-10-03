class_name TowerDefenseControl extends Node

const TOWER_DEFENSE_HAMMER_MODE = preload("uid://bg3jr7ygc5lkf")

@onready var npcTalkControl: NpcTalkControl = %NpcTalkControl

@onready var mapControl: TowerDefenseMapControl = %TowerDefenseMapControl
@onready var seedBank: TowerDefenseInGameSeedBank = %TowerDefenseInGameSeedBank
@onready var packetBank: TowerDefenseInGamePacketBank = %TowerDefenseInGamePacketBank
@onready var levelControl: TowerDefenseInGameLevelControl = %TowerDefenseInGameLevelControl
@onready var screenEffectControl: ScreenEffectControl = %ScreenEffectControl

@onready var characterNode: Node2D = %CharacterNode

@onready var seedBankAnimationPlayer: AnimationPlayer = %SeedBankAnimationPlayer
@onready var packetBankAnimationPlayer: AnimationPlayer = %PacketBankAnimationPlayer

@onready var cameraBeginMarker: Marker2D = %CameraBeginMarker
@onready var cameraRightViewMarker: Marker2D = %CameraRightViewMarker
@onready var cameraPreViewMarker: Marker2D = %CameraPreViewMarker
@onready var camera: Camera2D = %Camera

@onready var buttonPause: MainButton = %ButtonPause
@onready var checkBox2X: CheckBox = %CheckBox2X

@onready var towerDefenseZombieWon: TowerDefenseZombieWon = %TowerDefenseZombieWon
@onready var zombieWonArea: Area2D = %ZombieWonArea

@onready var gUILayerBack: CanvasLayer = %GUILayerBack

@export var levelConfig: TowerDefenseLevelConfig

@onready var optionButton: SpriteBrightButton = %OptionButton

signal viweBack()

var skipPacketChoose: bool = false
var isGameRunning: bool = false
var isGameFail: bool = false
var isView: bool = false

var waitPause: bool = false

var gameMode: TowerDefenseEnum.GAMEMODE = TowerDefenseEnum.GAMEMODE.TOWERDEFENSE:
    set(_gameMode):
        gameMode = _gameMode
        FreshGameMode()

var gameModeNode: Node

func FreshGameMode() -> void :
    if is_instance_valid(gameModeNode):
        gameModeNode.queue_free()
    match gameMode:
        TowerDefenseEnum.GAMEMODE.HAMMER:
            gameModeNode = TOWER_DEFENSE_HAMMER_MODE.instantiate()
            characterNode.get_parent().add_child(gameModeNode)

func Init(_levelConfig: TowerDefenseLevelConfig):
    TowerDefenseManager.currentLevelConfig = _levelConfig
    levelConfig = _levelConfig
    levelConfig.Init()

    match levelConfig.packetBankMethod:
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.RAIN:
            screenEffectControl.AddScreenEffect("Rain")

    var mapConfig: TowerDefenseMapConfig = TowerDefenseManager.GetMapConfig(levelConfig.map)
    mapControl.Init(mapConfig)

    cameraRightViewMarker.global_position.x = clamp(mapConfig.mapSize.x - get_viewport().get_visible_rect().size.x, 0, cameraRightViewMarker.global_position.x)
    cameraPreViewMarker.global_position.x = clamp(mapConfig.mapSize.x - get_viewport().get_visible_rect().size.x - 56, 0, cameraPreViewMarker.global_position.x)

    var recheckList: Array = []
    for preSpawn: TowerDefenseLevelPreSpawnConfig in levelConfig.preSpawnList:
        var characterSpawn = preSpawn.SpawnCharacter()
        if !is_instance_valid(characterSpawn):
            recheckList.append(preSpawn)
        else:
            if is_instance_valid(preSpawn.characterOverride):
                preSpawn.characterOverride.ExecuteCharacter(characterSpawn)
    for preSpawn: TowerDefenseLevelPreSpawnConfig in recheckList:
        var characterSpawn = preSpawn.SpawnCharacter()
        if is_instance_valid(characterSpawn):
            if is_instance_valid(preSpawn.characterOverride):
                preSpawn.characterOverride.ExecuteCharacter(characterSpawn)
    TowerDefenseManager.ExecuteLevelEvent(levelConfig.eventInit)

    levelControl.Init(levelConfig)

    if levelConfig.talk != "" || levelConfig.isCustomTalk:
        var talkFile: NpcTalkConfig
        var npcTalkGet: bool = false
        if levelConfig.talk != "":
            talkFile = TowerDefenseManager.GetNpcTalk(levelConfig.talk)
            talkFile.Init()
            npcTalkGet = GameSaveManager.GetTutorialValue(talkFile.saveKey)
        if levelConfig.isCustomTalk:
            talkFile = levelConfig.customTalk
        if !npcTalkGet:
            await get_tree().create_timer(1.5, false).timeout
            levelControl.backgroundAudio = AudioManager.AudioPlay("MainMenu", AudioManagerEnum.TYPE.MUSIC)
            npcTalkControl.Init(talkFile)
            await npcTalkControl.finish

    levelControl.LevelReady()
    levelControl.InitManager()

    seedBank.shovelNode.position.y = 0
    if GameSaveManager.GetConfigValue("MobilePreset"):
        seedBank.mobileConveyorBeltContainer.visible = false
        seedBank.mobileSeedContanin.visible = false
    else:
        seedBank.conveyorBeltContainer.visible = false
        seedBank.seedContanin.visible = false
    seedBank.rainModeControl.visible = false
    match levelConfig.packetBankMethod:
        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.NOONE:
            skipPacketChoose = true

        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE:
            if GameSaveManager.GetConfigValue("MobilePreset"):
                seedBank.mobileSeedContanin.visible = true
            else:
                seedBank.seedContanin.visible = true
            var packetBankData: TowerDefensePacketBankData
            if Global.debugPacketOpenAll:
                packetBankData = TowerDefenseManager.GetPacketBankData("Total")
            else:
                packetBankData = TowerDefenseManager.GetPacketBankData(levelConfig.packetBank)
            packetBank.Init(packetBankData)

            var unlockPacket: Array[String] = packetBankData.GetUnlockPacket()
            skipPacketChoose = unlockPacket.size() <= TowerDefenseManager.seedbankPacketMax

            for levelPacketConfig: TowerDefenseLevelPacketConfig in levelConfig.packetBankList:
                if !is_instance_valid(levelPacketConfig.override):
                    packetBank.PacketChooseFromName(levelPacketConfig.packetName, true)
                else:
                    var packetConfig: TowerDefensePacketConfig = levelPacketConfig.GetPacket()
                    var packet = seedBank.AddPacket(packetConfig)
                    packet.lock = true

            if !Global.debugPacketSelect:
                if skipPacketChoose:
                    for packetName: String in unlockPacket:
                        var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetName)
                        seedBank.AddPacket(packetConfig)
                    seedBank.Ready()

            if Global.debugPacketSelect:
                skipPacketChoose = false

        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.PRESET:
            if GameSaveManager.GetConfigValue("MobilePreset"):
                seedBank.mobileSeedContanin.visible = true
            else:
                seedBank.seedContanin.visible = true
            skipPacketChoose = true
            for levelPacketConfig: TowerDefenseLevelPacketConfig in levelConfig.packetBankList:
                var packetConfig: TowerDefensePacketConfig = levelPacketConfig.GetPacket()
                seedBank.AddPacket(packetConfig)
            seedBank.Ready()

            if Global.debugPacketSelect:
                skipPacketChoose = false

        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR:
            skipPacketChoose = true
            if GameSaveManager.GetConfigValue("MobilePreset"):
                seedBank.mobileConveyorBeltContainer.visible = true
                seedBank.mobileConveyorBelt.Init(levelConfig.conveyorData)
            else:
                seedBank.conveyorBeltContainer.visible = true
                seedBank.conveyorBelt.Init(levelConfig.conveyorData)

        TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.RAIN:
            skipPacketChoose = true
            seedBank.rainModeControl.visible = true
            seedBank.rainModeControl.Init(levelConfig.rainData)

    GameEntry()

func _ready() -> void :
    buttonPause.visible = false
    buttonPause.toggled.connect(ButtonPauseToggled)
    checkBox2X.visible = false
    checkBox2X.toggled.connect(CheckBox2XToggled)
    TowerDefenseManager.currentControl = self
    Init(TowerDefenseManager.currentLevelConfig)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if GameSaveManager.GetConfigValue("PacketUIFront") || GameSaveManager.GetConfigValue("MobilePreset"):
        gUILayerBack.layer = 2
    else:
        gUILayerBack.layer = 1
    if !waitPause:
        if isGameRunning && (Input.is_action_just_pressed("Pause") || ( !GameSaveManager.GetConfigValue("Backgrounder") && !DisplayServer.window_is_focused())):
            AudioManager.AudioPlay("Pause", AudioManagerEnum.TYPE.SFX, 0.0, true, true)
            DialogManager.DialogCreate("Pause")
            waitPause = true
            await get_tree().create_timer(0.1, false).timeout
            waitPause = false

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
    if isView:
        if Input.is_anything_pressed():
            viweBack.emit()
    if Input.is_action_just_pressed("SpeedUp"):
        checkBox2X.button_pressed = !checkBox2X.button_pressed
    if Input.is_action_just_pressed("PacketUIFront"):
        GameSaveManager.SetConfigValue("PacketUIFront", !GameSaveManager.GetConfigValue("PacketUIFront"))
        GameSaveManager.SaveGameConfig()
    if Input.is_action_just_pressed("ShowPlantHealth"):
        GameSaveManager.SetConfigValue("ShowPlantHealth", !GameSaveManager.GetConfigValue("ShowPlantHealth"))
        GameSaveManager.SaveGameConfig()
    if Input.is_action_just_pressed("ShowZombieHealth"):
        GameSaveManager.SetConfigValue("ShowZombieHealth", !GameSaveManager.GetConfigValue("ShowZombieHealth"))
        GameSaveManager.SaveGameConfig()

func GameEntry() -> void :
    var tween: Tween
    await get_tree().create_timer(0.5, false).timeout
    match levelConfig.finishMethod:
        TowerDefenseEnum.LEVEL_FINISH_METHOD.WAVE:
            levelControl.waveManager.ShowCharacter()
            levelControl.worldEntryLabel.visible = true
            get_tree().create_timer(2.0, false).timeout.connect(
                func():
                    levelControl.worldEntryLabel.visible = false
            )
            tween = camera.create_tween()
            tween.set_ease(Tween.EASE_IN_OUT)
            tween.set_trans(Tween.TRANS_QUAD)
            tween.tween_property(camera, "global_position:x", cameraRightViewMarker.global_position.x, 1.5)
            await tween.finished
            if !skipPacketChoose:
                tween = camera.create_tween()
                tween.set_ease(Tween.EASE_IN_OUT)
                tween.set_trans(Tween.TRANS_QUART)
                tween.tween_property(camera, "global_position:x", cameraPreViewMarker.global_position.x, 1.5)
                await tween.finished
                buttonPause.visible = true
                seedBank.packetSlotContainer.visible = true
                if GameSaveManager.GetConfigValue("MobilePreset"):
                    packetBankAnimationPlayer.play("MobileEnter")
                    seedBankAnimationPlayer.play("MobileEnter")
                else:
                    packetBankAnimationPlayer.play("Enter")
                    seedBankAnimationPlayer.play("Enter")
                await packetBank.chooseOver
                if GameSaveManager.GetConfigValue("MobilePreset"):
                    packetBankAnimationPlayer.play("MobileExit")
                else:
                    packetBankAnimationPlayer.play("Exit")
                await get_tree().create_timer(0.5, false).timeout
                seedBank.Ready()
            else:
                await get_tree().create_timer(0.5, false).timeout
            tween = camera.create_tween()
            tween.set_ease(Tween.EASE_IN_OUT)
            tween.set_trans(Tween.TRANS_SINE)
            tween.tween_property(camera, "global_position:x", cameraBeginMarker.global_position.x, 1.5)
            await tween.finished
            seedBank.packetSlotContainer.visible = true
            if skipPacketChoose:
                if GameSaveManager.GetConfigValue("MobilePreset"):
                    seedBankAnimationPlayer.play("MobileEnter")
                else:
                    seedBankAnimationPlayer.play("Enter")
            GameReady()
            await levelControl.ReadySetPlantPlay()
            GameStart()
        TowerDefenseEnum.LEVEL_FINISH_METHOD.VASE:
            match levelConfig.packetBankMethod:
                TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.NOONE:
                    seedBank.shovelNode.global_position.y = 0
                    seedBank.shovelShow = true
                TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CHOOSE, TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.PRESET, TowerDefenseEnum.LEVEL_SEEDBANK_METHOD.CONVEYOR:
                    if !skipPacketChoose:
                        if GameSaveManager.GetConfigValue("MobilePreset"):
                            packetBankAnimationPlayer.play("MobileEnter")
                            seedBankAnimationPlayer.play("MobileEnter")
                        else:
                            packetBankAnimationPlayer.play("Enter")
                            seedBankAnimationPlayer.play("Enter")
                        buttonPause.visible = true
                        seedBank.packetSlotContainer.visible = true
                        await packetBank.chooseOver
                        if GameSaveManager.GetConfigValue("MobilePreset"):
                            packetBankAnimationPlayer.play("MobileExit")
                        else:
                            packetBankAnimationPlayer.play("Exit")
                        await get_tree().create_timer(0.5, false).timeout
                        seedBank.Ready()
                    else:
                        if GameSaveManager.GetConfigValue("MobilePreset"):
                            seedBankAnimationPlayer.play("MobileEnter")
                        else:
                            seedBankAnimationPlayer.play("Enter")
            GameReady()
            GameStart()

func GameReady() -> void :
    match levelConfig.finishMethod:
        TowerDefenseEnum.LEVEL_FINISH_METHOD.WAVE:
            levelControl.waveManager.ClearShowCharacter()
    levelControl.waveManager.levelNameLabel.visible = true
    levelControl.waveManager.difficultLabel.visible = true
    if Global.enterLevelMode == "DailyLevel" || Global.enterLevelMode == "OnlineLevel" || Global.enterLevelMode == "LevelTest":
        levelControl.waveManager.difficultLabel.visible = false
    TowerDefenseManager.ExecuteLevelEvent(levelConfig.eventReady)
    if levelConfig.mowerUse:
        mapControl.MowerInit()

func GameStart() -> void :
    isGameRunning = true
    buttonPause.visible = true
    checkBox2X.visible = true
    optionButton.visible = true

    seedBank.Start()
    levelControl.LevelStart()
    TowerDefenseManager.ExecuteLevelEvent(levelConfig.eventStart)

    for character in TowerDefenseManager.GetCharacter():
        character.state.process_mode = Node.PROCESS_MODE_INHERIT
        character.call("Idle")

    for zombie in TowerDefenseManager.GetZombie():
        zombie.call("Walk")

func GameFail(enterCharacter: TowerDefenseCharacter) -> void :
    isGameFail = true
    for character: TowerDefenseCharacter in TowerDefenseManager.GetCharacter():
        if character != enterCharacter:
            character.process_mode = Node.PROCESS_MODE_DISABLED
    packetBank.visible = false
    seedBank.visible = false
    await mapControl.currentMap.EnterRoom(enterCharacter)
    if is_instance_valid(enterCharacter):
        enterCharacter.process_mode = Node.PROCESS_MODE_DISABLED
    levelControl.LevelFail()
    towerDefenseZombieWon.LevelFail()

@warning_ignore("unused_parameter")
func ButtonPauseToggled(toggled: bool) -> void :
    if toggled:
        AudioManager.AudioPlay("Pause", AudioManagerEnum.TYPE.SFX, 0.0, true, true)
        DialogManager.DialogCreate("BattlePause").close.connect(
            func():
                buttonPause.button_pressed = false
        )

func CheckBox2XToggled(toggled: bool) -> void :
    if toggled:

        AudioManager.AudioPlay("2XSpeedOn", AudioManagerEnum.TYPE.SFX)
        Global.timeScale = 1.5
    else:

        AudioManager.AudioPlay("2XSpeedDown", AudioManagerEnum.TYPE.SFX)
        Global.timeScale = 1.0

func ZombieWonAreaEntered(area: Area2D) -> void :
    var character = area.get_parent()
    if character is TowerDefenseZombie:
        if character.instance.die || character.instance.nearDie:
            return
        GameFail(character)

func ViewMap() -> void :
    match levelConfig.finishMethod:
        TowerDefenseEnum.LEVEL_FINISH_METHOD.WAVE:
            if GameSaveManager.GetConfigValue("MobilePreset"):
                packetBankAnimationPlayer.play("MobileExit")
            else:
                packetBankAnimationPlayer.play("Exit")
            var tween: Tween
            tween = camera.create_tween()
            tween.set_ease(Tween.EASE_IN_OUT)
            tween.set_trans(Tween.TRANS_SINE)
            tween.tween_property(camera, "global_position:x", cameraBeginMarker.global_position.x, 1.5)
            isView = true
            await tween.finished
            var broadCastConfig: BroadCastConfig = BroadCastConfig.new()
            broadCastConfig.broadCastString = "INGAME_VIEW_BACK"
            BroadCastManager.BroadCastAdd(broadCastConfig)
            await viweBack
            BroadCastManager.BraodCastClear()
            isView = false
            tween = camera.create_tween()
            tween.set_ease(Tween.EASE_IN_OUT)
            tween.set_trans(Tween.TRANS_SINE)
            tween.tween_property(camera, "global_position:x", cameraPreViewMarker.global_position.x, 1.5)
            await tween.finished
            if GameSaveManager.GetConfigValue("MobilePreset"):
                packetBankAnimationPlayer.play("MobileEnter")
            else:
                packetBankAnimationPlayer.play("Enter")
        TowerDefenseEnum.LEVEL_FINISH_METHOD.VASE:
            if GameSaveManager.GetConfigValue("MobilePreset"):
                packetBankAnimationPlayer.play("MobileExit")
            else:
                packetBankAnimationPlayer.play("Exit")
            isView = true
            var broadCastConfig: BroadCastConfig = BroadCastConfig.new()
            broadCastConfig.broadCastString = "INGAME_VIEW_BACK"
            BroadCastManager.BroadCastAdd(broadCastConfig)
            await viweBack
            BroadCastManager.BraodCastClear()
            isView = false
            if GameSaveManager.GetConfigValue("MobilePreset"):
                packetBankAnimationPlayer.play("MobileEnter")
            else:
                packetBankAnimationPlayer.play("Enter")

func ShopButtonPressed() -> void :
    DialogManager.DialogCreate("Shop")

func AlmanacButtonPressed() -> void :
    DialogManager.DialogCreate("Almanac")

func GUIMoveFront() -> void :
    gUILayerBack.layer = 2

func GUIMoveBack() -> void :
    gUILayerBack.layer = 0

func OptionButtonPressed() -> void :
    DialogManager.DialogCreate("BattleOption")
