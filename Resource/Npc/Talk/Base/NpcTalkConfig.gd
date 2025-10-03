@tool
class_name NpcTalkConfig extends Resource

@export var data: JSON:
    set(_data):
        data = _data
        Init()
        notify_property_list_changed()

@export var saveKey: String = ""
@export var talkList: Array[NpcTalkBaseConfig]

func Init() -> void :
    talkList.clear()
    if is_instance_valid(data):
        Load(data.data)

func Load(_data: Dictionary) -> void :
    saveKey = _data.get("SaveKey", "")
    var _talkList: Array = _data.get("Talk", [])
    for talkId in range(_talkList.size()):
        var talk: Dictionary = _talkList[talkId]
        match talk["Mode"]:
            "Default":
                var talkConfig: NpcTalkBaseConfig = NpcTalkBaseConfig.new()
                talkConfig.Init(talk)
                talkList.append(talkConfig)
            "Hand":
                var talkConfig: NpcTalkHandConfig = NpcTalkHandConfig.new()
                talkConfig.Init(talk)
                talkList.append(talkConfig)
            "Tutorial":
                var talkConfig: NpcTalkTutorialConfig = NpcTalkTutorialConfig.new()
                talkConfig.Init(talk)
                talkList.append(talkConfig)
