extends Node2D

@onready var versionHttpRequest: HTTPRequest = %VersionHTTPRequest
@onready var dailyLevelHTTPRequest: HTTPRequest = %DailyLevelHTTPRequest
@onready var onlineLevelHTTPRequest: HTTPRequest = %OnlineLevelHTTPRequest

signal onlineLevelGet(data: Dictionary)

var versionGetOver: bool = false
var newVersion: String = ""

var dailyLevelGetOver: bool = false

func _ready() -> void :
    versionHttpRequest.request("https://api.pvzhe.com/new_version", Global.header)

@warning_ignore("unused_parameter")
func VersionHTTPRequestCompleted(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void :
    var json = JSON.new()
    json.parse(body.get_string_from_utf8())
    if json.data:
        versionGetOver = true
        var response = json.get_data()
        var getVersion: Array = response["pc"].get("version", [-1, -1, -1, -1])
        var base64: String = response["pc"].get("base64", "error")
        Global.uri = response["pc"].get("url", "error")
        var stringList: PackedStringArray = []
        for number in getVersion:
            stringList.append(str(int(number)))
        newVersion = ".".join(stringList)
        prints("newVersion:", newVersion)
        prints("uri:", Global.uri)
        prints("base64:", base64)
        if base64 != "error":
            var checkString = Marshalls.base64_to_utf8(base64)
            print("checkString:", checkString)
            if checkString == newVersion + Global.uri:
                Global.newVersion = newVersion
                var flag: bool = true
                var vesionSplit = Global.version.split(".")
                for ind in getVersion.size():
                    if vesionSplit[ind].to_int() > int(getVersion[ind]):
                        flag = false
                        break
                Global.hasNewVersion = flag
                if !Global.hasNewVersion:
                    GetDailyLevel()

func GetDailyLevel() -> void :
    dailyLevelHTTPRequest.cancel_request()
    dailyLevelHTTPRequest.request("https://api.pvzhe.com/get_daily_levels", Global.header)

@warning_ignore("unused_parameter")
func DailyLevelHTTPRequestCompleted(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void :
    var json = JSON.new()
    json.parse(body.get_string_from_utf8())
    if json.data:
        ResourceManager.DAILY_LEVEL_DATA = json.get_data()
        dailyLevelGetOver = true


func GetOnlineLevelPage(pageIndex: int = 1, suffix: String = "") -> void :
    pageIndex = clamp(pageIndex, 1, 100000)
    onlineLevelHTTPRequest.cancel_request()
    onlineLevelHTTPRequest.request("https://api.pvzhe.com/workshop/levels?page=%d%s" % [pageIndex, suffix], Global.header)

@warning_ignore("unused_parameter")
func OnlineLevelHTTPRequestCompleted(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void :
    var json = JSON.new()
    json.parse(body.get_string_from_utf8())
    if json.data:
        onlineLevelGet.emit(json.data)
