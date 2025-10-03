@tool
extends Node

var version: String = "0.5.0.0"
var header: PackedStringArray = []
var isMobile: bool = false
signal animeFrameRateChange()

@export_tool_button("Fresh AllAnimeData") var freshAnimeData: Callable = FreshAnimeData

@export var debug: bool = false
@export_group("Base")
@export var animeFrameRate: float = 30.0:
    set(_animeFrameRate):
        animeFrameRate = _animeFrameRate
        Engine.max_fps = int(animeFrameRate)
        Engine.physics_ticks_per_second = min(60, animeFrameRate)
        animeFrameRateChange.emit()
@export var trueAnimeFrameRate: float:
    get():
        return animeFrameRate / timeScale

@export var timeScale: float = 1.0:
    set(_timeScale):
        timeScale = _timeScale
        Engine.time_scale = timeScale
        animeFrameRateChange.emit()

@export_group("Coin")
@export var debugCoinMax: bool = false
@export_group("Level")
@export var debugOpenAllLevel: bool = false
@export_group("InGame/Default")
@export var debugSunMax: bool = false
@export_group("InGame/Packet")
@export var debugPacketSelect: bool = false
@export var debugPacketOpenAll: bool = false
@export var debugPacketColdDown: bool = false
@export_group("InGame/Character")
@export var debugOpenAllCustom: bool = false

var enterLevelMode: String = "LevelChoose"
var currentLevelChoose: String = "Adventure"
var currentChapterId: int = -1
var currentLevelId: int = -1
var currentAwardMode: bool = false
var currentAwardType: TowerDefenseEnum.LEVEL_REWARDTYPE = TowerDefenseEnum.LEVEL_REWARDTYPE.NOONE
var currentAwardValue: String = ""
var currentDiyLevelUid: String = ""

var newVersion: String = ""
var hasNewVersion: bool = false
var uri: String = ""
var newVersionSkip: bool = false

var maxFps: int = 60

var isEditor: bool = false

func _ready() -> void :
    header.append("X-PVZHE-Client-Version:0.5")
    get_window().close_requested.connect(
        func():
            GameSaveManager.Save()
    )
    var osName: String = OS.get_name()
    isMobile = osName == "Android" || osName == "iOS"
    TranslationServer.set_locale("zh")
    maxFps = int(DisplayServer.screen_get_refresh_rate(DisplayServer.window_get_current_screen()))

    if isMobile:
        OS.request_permissions()












@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    AdobeAnimateSprite.animeFreshNum = 0

func FreshAnimeData() -> void :
    var thread: Thread = Thread.new()
    thread.start(FreshAnimeDataOpenDir.bind("res://"))

func FreshAnimeDataOpenDir(path: String) -> void :
    var dir = DirAccess.open(path)
    if dir:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            if dir.current_is_dir():
                print("发现文件夹" + path + "//" + file_name)
                FreshAnimeDataOpenDir(path + "//" + file_name)
            else:
                print("发现文件" + path + "//" + file_name)
                if file_name.get_extension() == "tres":
                    var file = load(path + "//" + file_name)
                    if file is AdobeAnimateData:
                        file.Init()
                        ResourceSaver.save(file, path + "//" + file_name, ResourceSaver.FLAG_COMPRESS)
            file_name = dir.get_next()
    else:
        print("尝试访问路径时出错。")
