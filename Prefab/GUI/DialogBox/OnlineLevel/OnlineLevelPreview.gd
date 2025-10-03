extends DialogBoxBase

@onready var levelInformationGetHTTPRequest: HTTPRequest = %LevelInformationGetHTTPRequest

@onready var nameLabel: Label = %NameLabel
@onready var mapTexture: TextureRect = %MapTexture
@onready var playButton: MainButton = %PlayButton
@onready var closeButton: TextureButton = %CloseButton

@onready var authorLabel: RichTextLabel = %AuthorLabel
@onready var describeLabel: RichTextLabel = %DescribeLabel
@onready var levelIdLabel: RichTextLabel = %LevelIDLabel
@onready var playedNumLabel: RichTextLabel = %PlayedNumLabel
@onready var dateLabel: RichTextLabel = %DateLabel

@onready var collectionButton: TextureButton = %CollectionButton

signal select(url: String)

var levelData: Dictionary = {}
var id: String = ""
var levelName: String = ""
var map: String = ""
var author: String = ""
var description: String = ""
var fileUrl: String = ""
var playedNum: int = 0
var date: int = 0

var loadOver: bool = false

func InitDialog(_id: String) -> void :
    var url: String = "https://api.pvzhe.com/workshop/levels/%s" % _id
    levelInformationGetHTTPRequest.request(url, Global.header)

func InitDialogData(_levelData: Dictionary) -> void :
    levelData = _levelData
    id = levelData.get("id", "")
    levelName = levelData.get("name", "")
    map = levelData.get("map", "")
    author = levelData.get("author", "")
    description = levelData.get("description", "")
    fileUrl = levelData.get("fileUrl", "")
    playedNum = levelData.get("plays", "")
    date = levelData.get("uploadTime", "")

    nameLabel.text = levelName
    var mapConfig: TowerDefenseMapConfig = TowerDefenseManager.GetMapConfig(map)
    mapTexture.texture = mapConfig.mapTexture

    authorLabel.text = "作者:%s" % author
    describeLabel.text = "简介:%s" % description
    levelIdLabel.text = "关卡ID:%s" % id
    playedNumLabel.text = "游玩次数:%d" % playedNum
    dateLabel.text = "上传日期:%s" % Time.get_datetime_string_from_unix_time(date)

    var myCollectionData: Dictionary = GameSaveManager.GetKeyValue("OnlineMyCollection")
    var myCollectionList: Array = myCollectionData.get("Level", [])
    for data: Dictionary in myCollectionList:
        var colectionLevelId: String = data.get("id", "-1")
        if colectionLevelId == id:
            collectionButton.button_pressed = true
            break
    collectionButton.disabled = false
    collectionButton.toggled.connect(CollectionButtonToggled)
    loadOver = true

func CloseButtonPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    Close()

func PlayButtonPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    if loadOver:
        print(fileUrl)
        select.emit(fileUrl)
        playButton.disabled = true
        closeButton.disabled = true
    else:
        BroadCastManager.BroadCastFloatCreate("关卡正在加载中...", Color.RED)

@warning_ignore("unused_parameter")
func LevelInformationGetHTTPRequestCompleted(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void :
    var json = JSON.new()
    json.parse(body.get_string_from_utf8(), true)
    if json.data:
        InitDialogData(json.data)

func CollectionButtonToggled(toggledOn: bool) -> void :
    var myCollectionData: Dictionary = GameSaveManager.GetKeyValue("OnlineMyCollection")
    var myCollectionList: Array = myCollectionData.get("Level", []) as Array
    if toggledOn:
        myCollectionList.append(
            {
                "id": id, 
                "name": levelName, 
                "map": map
            }
        )
    else:
        for index in myCollectionList.size():
            var data: Dictionary = myCollectionList[index]
            if data.get("id", "-1") == id:
                myCollectionList.remove_at(index)
                break
    myCollectionData["Level"] = myCollectionList
    GameSaveManager.SetKeyValue("OnlineMyCollection", myCollectionData)
