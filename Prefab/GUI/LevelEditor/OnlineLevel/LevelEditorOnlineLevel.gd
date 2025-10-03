extends Control

const LEVEL_EDITOR_ONLINE_LEVEL_ITEM = preload("uid://7tkumqfm20gv")

@onready var levelGetHTTPRequest: HTTPRequest = %LevelGetHTTPRequest
@onready var levelInformationGetHTTPRequest: HTTPRequest = %LevelInformationGetHTTPRequest

@onready var onlineLevelContainer: HFlowContainer = %OnlineLevelContainer
@onready var levelContainer: MarginContainer = %LevelContainer
@onready var pageLabel: Label = %PageLabel

@onready var levelIdLineEdit: LineEdit = %LevelIdLineEdit
@onready var enterLevelButton: MainButton = %EnterLevelButton

@onready var jumpPageToSpinBox: SpinBox = %JumpPageToSpinBox
@onready var jumpPageToButton: MainButton = %JumpPageToButton


var levelNum: int = 1
var maxPage: int = 1
var currentPage: int = -1
var currentPageList: Array = []
var suffix: String = ""
var currentLevelId: String = ""

var myCollection: bool = false

func _ready() -> void :
    InternetServerManager.onlineLevelGet.connect(LoadPageData)
    GetPage()

func GetPage(pageIndex: int = 1) -> void :
    levelContainer.visible = false
    for node in onlineLevelContainer.get_children():
        node.queue_free()

    if !myCollection:
        InternetServerManager.GetOnlineLevelPage(pageIndex, suffix)
    else:
        LoadMyCollectionPage(pageIndex)

func LoadMyCollectionPage(pageIndex: int = 1) -> void :
    levelContainer.visible = true
    var myCollectionData: Dictionary = GameSaveManager.GetKeyValue("OnlineMyCollection")
    var myCollectionList: Array = myCollectionData.get("Level", [])
    levelNum = myCollectionList.size()
    currentPage = pageIndex
    maxPage = ceil(myCollectionList.size() / 10.0)
    PageLabelFresh()
    for levelIndex in range((currentPage - 1) * 10, min(1 + (currentPage - 1) * 10 + 10, levelNum), 1):
        var levelData: Dictionary = myCollectionList[levelIndex]
        var levelId: String = levelData.get("id", "-1")
        if levelId != "-1":
            var item = LEVEL_EDITOR_ONLINE_LEVEL_ITEM.instantiate()
            onlineLevelContainer.add_child(item)
            item.Init(levelData)
            item.select.connect(EnterLevel)

func LoadPageData(data: Dictionary) -> void :
    if myCollection:
        return
    levelContainer.visible = true
    levelNum = data.get("total", 1)
    currentPage = data.get("page", 1)
    maxPage = data.get("maxPage", 1)
    currentPageList = data.get("list", [])
    PageLabelFresh()
    for levelData: Dictionary in currentPageList:
        var levelId: String = levelData.get("id", "-1")
        if levelId != "-1":
            var item = LEVEL_EDITOR_ONLINE_LEVEL_ITEM.instantiate()
            onlineLevelContainer.add_child(item)
            item.Init(levelData)
            item.select.connect(EnterLevel)

func PageLabelFresh() -> void :
    jumpPageToSpinBox.max_value = maxPage
    pageLabel.text = "第%d页，共%d页" % [currentPage, maxPage]

func PreButtonPressed() -> void :
    if currentPage == -1:
        return
    var page = currentPage - 1
    if page < 1:
        page = maxPage
    GetPage(page)

func NextButtonpressed() -> void :
    if currentPage == -1:
        return
    var page = currentPage + 1
    if page > maxPage:
        page = 1
    GetPage(page)

func EnterLevelButtonPressed() -> void :
    if levelIdLineEdit.text == "":
        return
    var url: String = "https://api.pvzhe.com/workshop/levels/%s" % levelIdLineEdit.text
    levelInformationGetHTTPRequest.request(url, Global.header)
    enterLevelButton.disabled = true

func JumpPageToButtonPressed() -> void :
    GetPage(int(jumpPageToSpinBox.value))

func ToBattle(json: JSON) -> void :
    var config: TowerDefenseLevelConfig = TowerDefenseLevelConfig.new()
    config.data = json
    config.Init()
    TowerDefenseManager.currentLevelConfig = config
    Global.enterLevelMode = "OnlineLevel"
    SceneManager.ChangeScene("TowerDefense")

func EnterLevel(url: String, id: String) -> void :
    currentLevelId = id
    if url != "":
        var fileUrl: String = "https://api.pvzhe.com%s" % url
        levelGetHTTPRequest.request(fileUrl, Global.header)

@warning_ignore("unused_parameter")
func LevelGetHTTPRequestCompleted(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void :
    @warning_ignore("unused_variable")
    var levelName: String = "OnlineLevel-%s" % currentLevelId
    var json = JSON.new()
    json.parse(body.get_string_from_utf8(), true)
    if json.data:
        if json.data.has("error"):
            if json.data["error"]:
                BroadCastManager.BroadCastFloatCreate("关卡Id无效", Color.RED)
                return
        json.data["Name"] = levelName
        json.data["Reward"] = {}
        json.data["Reward"]["RewardType"] = "Coin"
        json.data["Reward"]["RewardFirst"] = "1000"
        var saveJson = JSON.new()
        saveJson.parse(JSON.stringify(json.data), true)
        GameSaveManager.SaveOnlineLevel(levelName, saveJson)
        ToBattle(saveJson)

@warning_ignore("unused_parameter")
func LevelInformationGetHTTPRequestCompleted(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void :
    var json = JSON.new()
    json.parse(body.get_string_from_utf8(), true)
    if json.data:
        var _id = json.data.get("id", "-1")
        if _id != "-1":
            var dialog = DialogManager.DialogCreate("OnlineLevelPreview")
            dialog.InitDialogData(json.data)
            dialog.select.connect(EnterLevel.bind(_id))
        else:
            BroadCastManager.BroadCastFloatCreate("关卡Id无效", Color.RED)
    else:
        BroadCastManager.BroadCastFloatCreate("关卡Id无效", Color.RED)
    enterLevelButton.disabled = false

func MyCollectionButtonPressed() -> void :
    myCollection = true
    suffix = ""
    GetPage(1)

func OfficialRecommendationButtonPressed() -> void :
    myCollection = false
    suffix = "&feature=rec"
    GetPage(1)

func SortByTimeButtonPressed() -> void :
    myCollection = false
    suffix = ""
    GetPage(1)

func SortByNumberOfPlayedButtonPressed() -> void :
    myCollection = false
    suffix = "&sort=plays"
    GetPage(1)
