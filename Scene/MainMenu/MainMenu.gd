class_name MainMenu extends Control

@onready var camera: Camera2D = %Camera
@onready var moreGameMarker: Marker2D = %MoreGameMarker
@onready var defaultMarker: Marker2D = %DefaultMarker

@onready var helpButton: TextureButton = %HelpTextureButton
@onready var optionButton: TextureButton = %OptionTextureButton
@onready var quitButton: TextureButton = %QuitTextureButton
@onready var woodButton: TextureButton = %WoodFileButton
@onready var adventureButton: TextureButton = %AdventureButton
@onready var challengeButton: TextureButton = %ChallengeButton
@onready var survivalButton: TextureButton = %SurvivalButton

@onready var woodNameLabel: RichTextLabel = %WoodNameLabel
@onready var woodFileButton: TextureButton = %WoodFileButton

@onready var selectAnimationPlayer: AnimationPlayer = %SelectAnimationPlayer

@onready var currentVersionLabel: Label = %CurrentVersionLabel
@onready var newVersionLinkButton: LinkButton = %NewVersionLinkButton

@onready var shopButton: TextureButton = %ShopButton

var choose: bool = false
var wait: bool = false

func _ready() -> void :
    if ( !Global.newVersionSkip && Global.hasNewVersion) || GameSaveManager.GetUserCurrent() == "":
        wait = true
    currentVersionLabel.text = "当前版本:%s" % Global.version
    AudioManager.AudioPlay("MainMenu", AudioManagerEnum.TYPE.MUSIC)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    shopButton.visible = GameSaveManager.GetFeatureValue("Shop")
    if GameSaveManager.GetUserCurrent() != "":
        woodNameLabel.text = GameSaveManager.GetUserCurrent() + "!"

func AdventureButtonPressed() -> void :
    if wait:
        return
    Global.currentLevelChoose = "Adventure"
    SceneManager.ChangeScene("LevelChoose")
    adventureButton.global_position += Vector2.ONE * 2

func ChallengeButtonPressed() -> void :
    if wait:
        return
    adventureButton.global_position += Vector2.ONE * 2

func SurvivalButtonPressed() -> void :
    if wait:
        return

    adventureButton.global_position += Vector2.ONE * 2

func MoreButtonPressed() -> void :
    if wait:
        return
    AudioManager.AudioPlay("GraveButtonPress", AudioManagerEnum.TYPE.SFX)
    var tween = camera.create_tween()
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.set_trans(Tween.TRANS_QUAD)
    tween.tween_property(camera, "global_position:x", moreGameMarker.global_position.x, 1.0)

func AlmanacButtonPressed() -> void :
    if wait:
        return
    DialogManager.DialogCreate("Almanac")

func ShopButtonPressed() -> void :
    if wait:
        return
    DialogManager.DialogCreate("Shop")

func DiyButtonPressed() -> void :
    if wait:
        return
    if Global.hasNewVersion:
        BroadCastManager.BroadCastFloatCreate("使用此功能需更新至最新版本", Color.RED)
        return
    SceneManager.ChangeScene("LevelEditorStage")

func MoreBackButtonPressed() -> void :
    if wait:
        return
    AudioManager.AudioPlay("GraveButtonPress", AudioManagerEnum.TYPE.SFX)
    var tween = camera.create_tween()
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.set_trans(Tween.TRANS_QUAD)
    tween.tween_property(camera, "global_position:x", defaultMarker.global_position.x, 1.0)

func HelpPressed() -> void :
    if wait:
        return
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    DialogManager.DialogCreate("Help")

func OptionButtonPressed() -> void :
    if wait:
        return
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    DialogManager.DialogCreate("MainMenuOption")

func ExitButtonPressed() -> void :
    if wait:
        return
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    DialogManager.DialogCreate("ExitGame")

func NewUser() -> void :
    DialogManager.DialogCreate("NewUser")

func WoodFileButtonPressed() -> void :
    if wait:
        return
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    await DialogManager.DialogCreate("User").close
    request_ready()

func DailyChallengeButtonPressed() -> void :
    if Global.hasNewVersion:
        BroadCastManager.BroadCastFloatCreate("使用此功能需更新至最新版本", Color.RED)
        return
    if !InternetServerManager.dailyLevelGetOver:
        InternetServerManager.GetDailyLevel()
        BroadCastManager.BroadCastFloatCreate("正在获取每日挑战列表,请稍后重试", Color.RED)
        return
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    await DialogManager.DialogCreate("DailyChallenge").close


func AnimeFinish(anim_name) -> void :
    if Global.hasNewVersion:
        newVersionLinkButton.visible = true
        newVersionLinkButton.text = "最新版本:%s(点此跳转更新)" % Global.newVersion
        newVersionLinkButton.uri = Global.uri
        if !Global.newVersionSkip:
            var newVersionDialog = DialogManager.DialogCreate("NewVersion")
            newVersionDialog.uri = Global.uri
            await newVersionDialog.close
            Global.newVersionSkip = true
    wait = false
    if anim_name == "Enter" && GameSaveManager.GetUserCurrent() == "":
        NewUser()
