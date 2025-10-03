class_name TowerDefenseInGameLevelControl extends Control

@onready var waveManager: TowerDefenseInGameWaveManager = %TowerDefenseInGameWaveManager
@onready var vaseManager: TowerDefenseInGameVaseManager = %TowerDefenseInGameVaseManager

@onready var sunManager: TowerDefenseInGameSunManager = %TowerDefenseInGameSunManager

@onready var worldEntryLabel: RichTextLabel = %WorldEntryLabel
@onready var tipsLabel: Label = %TipsLabel
@onready var animationPlayer: AnimationPlayer = %AnimationPlayer

static  var instance: TowerDefenseInGameLevelControl = null

var backgroundAudio: AudioStreamPlayerMember
var backgroundDrumsAudio: AudioStreamPlayerMember

var config: TowerDefenseLevelConfig
var backgroundMusicConfig: TowerDefenseBackgroundMusicConfig

var awardPos: Vector2 = Vector2.ZERO
var awardCreate: bool = false
var awardCheckTime: float = 0.5

func Init(_config: TowerDefenseLevelConfig) -> void :
    config = _config
    config.Init()
    backgroundMusicConfig = TowerDefenseManager.GetBackgroundMusicConfig(config.backgroundMusic)
    var text = tr(config.description).replace("{UserName}", GameSaveManager.GetUserCurrent())
    worldEntryLabel.text = text

func InitManager() -> void :
    match config.finishMethod:
        TowerDefenseEnum.LEVEL_FINISH_METHOD.WAVE:
            waveManager.Init(config.waveManager)
        TowerDefenseEnum.LEVEL_FINISH_METHOD.VASE:
            vaseManager.Init(config.vaseManager)
    sunManager.Init(config.sunManager)

func _ready() -> void :
    instance = self
    worldEntryLabel.visible = false

func _physics_process(delta: float) -> void :
    if is_instance_valid(backgroundDrumsAudio):
        if TowerDefenseManager.GetZombie().size() >= 10:
            backgroundDrumsAudio.volumeScale = lerpf(backgroundDrumsAudio.volumeScale, 1.0, delta * 1.0)
        else:
            backgroundDrumsAudio.volumeScale = lerpf(backgroundDrumsAudio.volumeScale, 0.0, delta * 1.0)
    if !awardCreate:
        if awardCheckTime > 0:
            awardCheckTime -= delta
        awardCheckTime = 0.5
        match config.finishMethod:
            TowerDefenseEnum.LEVEL_FINISH_METHOD.WAVE:
                if waveManager.waveFinal:
                    if CheckFinal():
                        AwardCreate(awardPos)
            TowerDefenseEnum.LEVEL_FINISH_METHOD.VASE:
                if CheckFinal():
                    AwardCreate(awardPos)

func ReadySetPlantPlay() -> void :
    if is_instance_valid(backgroundAudio):
        backgroundAudio.stop()
    if is_instance_valid(backgroundDrumsAudio):
        backgroundDrumsAudio.stop()
    AudioManager.AudioPlay("ReadySetPlants", AudioManagerEnum.TYPE.SFX)
    animationPlayer.play("ReadySetPlants")
    await get_tree().create_timer(2.0, false).timeout

func TipsPlay(text: String, duration: float = 2.0) -> void :
    tipsLabel.visible = true
    tipsLabel.text = text
    animationPlayer.play("Tips")
    await get_tree().create_timer(duration, false).timeout
    tipsLabel.visible = false

func LevelReady() -> void :
    if is_instance_valid(backgroundAudio):
        backgroundAudio.stop()
    if is_instance_valid(backgroundDrumsAudio):
        backgroundDrumsAudio.stop()
    if backgroundMusicConfig.entry != "":
        backgroundAudio = AudioManager.AudioPlay(backgroundMusicConfig.entry, AudioManagerEnum.TYPE.MUSIC, 0.0, false, false)

    var useLine: Array[int] = []
    var usePitchfork: String = "Pitchfork"
    var pitchforkNum: int = GameSaveManager.GetFeatureValue("Pitchfork")
    var sunPitchforkNum: int = GameSaveManager.GetFeatureValue("PitchforkSun")
    if sunPitchforkNum > 0:
        usePitchfork = "PitchforkSun"
        pitchforkNum = sunPitchforkNum
    if pitchforkNum > 0:
        for i in TowerDefenseMapControl.instance.lineUse.size():
            if !TowerDefenseMapControl.instance.lineUse[i]:
                continue
            if TowerDefenseMapControl.instance.LineHasType(i, TowerDefenseEnum.PLANTGRIDTYPE.WATER):
                continue
            useLine.append(i)
        if useLine.size() > 0:
            GameSaveManager.SetFeatureValue(usePitchfork, pitchforkNum - 1)
            var packet: TowerDefensePacketConfig
            match usePitchfork:
                "Pitchfork":
                    packet = TowerDefenseManager.GetPacketConfig("ItemRake")
                "PitchforkSun":
                    packet = TowerDefenseManager.GetPacketConfig("ItemRakeSun")
            waveManager.savePitchforkLine = useLine.pick_random()
            packet.Plant(Vector2(5, waveManager.savePitchforkLine), false)

func LevelStart() -> void :
    if is_instance_valid(backgroundAudio):
        backgroundAudio.stop()

    if backgroundMusicConfig.flag1 != "":
        backgroundAudio = AudioManager.AudioPlay(backgroundMusicConfig.flag1, AudioManagerEnum.TYPE.MUSIC, 0.0, false, false)
    if backgroundMusicConfig.drums != "":
        backgroundDrumsAudio = AudioManager.AudioPlay(backgroundMusicConfig.drums, AudioManagerEnum.TYPE.MUSIC, 0.0, false, false)
        backgroundDrumsAudio.volumeScale = 0.0
    sunManager.Running()
    if config.tutorial != "" || config.isCustomTutorial:
        var tutorial: TutorialConfig
        var tutorialGet: bool = false
        if config.tutorial != "":
            tutorial = TowerDefenseManager.GetTutorial(config.tutorial)
            tutorial.Init()
            tutorialGet = GameSaveManager.GetTutorialValue(tutorial.saveKey)
        if config.isCustomTutorial:
            tutorial = config.customTutorial

        if !tutorialGet:
            TutorialManager.TutorialEnter(tutorial)
            await TutorialManager.tutorialFinish
    match config.finishMethod:
        TowerDefenseEnum.LEVEL_FINISH_METHOD.WAVE:
            waveManager.StartWave()

func LevelFail() -> void :
    waveManager.isRunning = false
    waveManager.visible = false
    sunManager.isRunning = false

func CheckFinal() -> bool:
    match config.finishMethod:
        TowerDefenseEnum.LEVEL_FINISH_METHOD.WAVE:
            var targetList: Array = TowerDefenseManager.GetCampTarget(TowerDefenseEnum.CHARACTER_CAMP.PLANT)
            var targetNum: int = targetList.size()
            for target: TowerDefenseCharacter in targetList:
                if target.instance.die == true:
                    targetNum -= 1
            if targetNum > 0:
                awardPos = targetList[0].global_position
            if targetNum == 0:
                for target: TowerDefenseCharacter in targetList:
                    target.Destroy()
            return targetNum <= 0
        TowerDefenseEnum.LEVEL_FINISH_METHOD.VASE:
            var vaseList: Array = get_tree().get_nodes_in_group("Vase")
            if vaseList.size() > 0:
                return false
            var targetList: Array = TowerDefenseManager.GetCampTarget(TowerDefenseEnum.CHARACTER_CAMP.PLANT)
            var targetNum: int = targetList.size()
            for target: TowerDefenseCharacter in targetList:
                if target.instance.die == true:
                    targetNum -= 1
            if targetNum > 0:
                awardPos = targetList[0].global_position
            if targetNum == 0:
                for target: TowerDefenseCharacter in targetList:
                    target.Destroy()
            return targetNum <= 0
    return false

func AwardCreate(pos: Vector2) -> void :
    if awardCreate:
        return
    awardCreate = true
    if (Global.isEditor && Global.enterLevelMode == "DiyLevel") || Global.enterLevelMode == "LoadLevel":
        if Global.enterLevelMode == "DiyLevel":
            TowerDefenseManager.currentLevelConfig.canExport = true
        SceneManager.ChangeScene("LevelEditorStage")
        return
    if config.talk != "":
        var talkFile: NpcTalkConfig = TowerDefenseManager.GetNpcTalk(config.talk)
        GameSaveManager.SetTutorialValue(talkFile.saveKey, true)
    if config.tutorial != "":
        var tutorial: TutorialConfig = TowerDefenseManager.GetTutorial(config.tutorial)
        GameSaveManager.SetTutorialValue(tutorial.saveKey, true)
    var mapControl: TowerDefenseMapControl = TowerDefenseManager.GetMapControl()
    var firstAward: bool = false
    var difficult: String = GameSaveManager.GetKeyValue("CurrentDifficult")
    var levelData: Dictionary = GameSaveManager.GetLevelValue(config.name)
    var finishNum = levelData.get_or_add("Key", {}).get_or_add("Finish", 0)
    levelData["Key"]["Finish"] = finishNum + 1
    if !mapControl.mowerHasRun:
        levelData["Mower"] = true
    var difficultValue: bool = levelData.get_or_add(difficult, false)
    if !difficultValue:
        levelData[difficult] = true
    GameSaveManager.SetLevelValue(config.name, levelData)

    Global.currentAwardType = config.firstRewardType
    match config.firstRewardType:
        TowerDefenseEnum.LEVEL_REWARDTYPE.PACKET:
            if typeof(config.firstRewardValue) == TYPE_STRING:
                var packetData: Dictionary = GameSaveManager.GetTowerDefensePacketValue(config.firstRewardValue)
                if !packetData.get_or_add("Unlock", false):
                    packetData["Unlock"] = true
                    GameSaveManager.SetTowerDefensePacketValue(config.firstRewardValue, packetData)
                    Global.currentAwardValue = config.firstRewardValue
                    firstAward = true

            if typeof(config.firstRewardValue) == TYPE_ARRAY:
                for value in config.firstRewardValue:
                    var packetData: Dictionary = GameSaveManager.GetTowerDefensePacketValue(value)
                    if !packetData.get_or_add("Unlock", false):
                        packetData["Unlock"] = true
                        GameSaveManager.SetTowerDefensePacketValue(value, packetData)
                        if !firstAward:
                            Global.currentAwardValue = value
                            firstAward = true

        TowerDefenseEnum.LEVEL_REWARDTYPE.COLLECTABLE:
            if typeof(config.firstRewardValue) == TYPE_STRING:
                if !GameSaveManager.GetFeatureValue(config.firstRewardValue):
                    GameSaveManager.SetFeatureValue(config.firstRewardValue, true)
                    Global.currentAwardValue = config.firstRewardValue
                    firstAward = true

            if typeof(config.firstRewardValue) == TYPE_ARRAY:
                for value in config.firstRewardValue:
                    if !GameSaveManager.GetFeatureValue(value):
                        GameSaveManager.SetFeatureValue(value, true)
                        if !firstAward:
                            Global.currentAwardValue = value
                            firstAward = true

        TowerDefenseEnum.LEVEL_REWARDTYPE.COIN:
            if typeof(config.firstRewardValue) == TYPE_STRING:
                if levelData["Key"]["Finish"] == 1:
                    if !firstAward:
                        Global.currentAwardValue = config.firstRewardValue
                        firstAward = true

    if !firstAward:
        Global.currentAwardType = TowerDefenseEnum.LEVEL_REWARDTYPE.NOONE
        TowerDefenseManager.CreateAward(TowerDefenseEnum.LEVEL_REWARDTYPE.NOONE, "250", pos)
    else:
        TowerDefenseManager.CreateAward(config.firstRewardType, Global.currentAwardValue, pos)
    GameSaveManager.Save()
